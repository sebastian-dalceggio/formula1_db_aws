resource "aws_api_gateway_rest_api" "api_db" {
  name = "api_db"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [aws_vpc_endpoint.api_endpoint.id]
  }
}

resource "aws_api_gateway_resource" "get_table" {
  rest_api_id = aws_api_gateway_rest_api.api_db.id
  parent_id   = aws_api_gateway_rest_api.api_db.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id      = aws_api_gateway_rest_api.api_db.id
  resource_id      = aws_api_gateway_resource.get_table.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_db.id
  resource_id             = aws_api_gateway_resource.get_table.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_db.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_db.id
  triggers = {
    redeploymemt = sha1(jsonencode(aws_api_gateway_rest_api.api_db.body))
  }

  depends_on = [aws_api_gateway_integration.integration]

  lifecycle {
    create_before_destroy = true
  }


}

resource "aws_api_gateway_stage" "api_db_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_db.id
  stage_name    = "api_db_stage"
}

resource "aws_api_gateway_rest_api_policy" "api_policy" {
  rest_api_id = aws_api_gateway_rest_api.api_db.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_vpc_endpoint" "api_endpoint" {
  vpc_id              = aws_vpc.vpc_main.id
  service_name        = "com.amazonaws.${var.region}.execute-api"
  security_group_ids  = [aws_security_group.http_security_group.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.public_subnets[*].id
}