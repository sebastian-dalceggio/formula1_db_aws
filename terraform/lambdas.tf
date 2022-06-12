resource "aws_lambda_function" "create_tables" {
  image_uri    = docker_registry_image.load_data.name
  package_type = "Image"
  timeout      = 300
  vpc_config {
    security_group_ids = ["${aws_security_group.lambda-security-group.id}"]
    subnet_ids         = [aws_subnet.private-subnet-az1.id, aws_subnet.private-subnet-az2.id]
  }
  function_name = "create_tables"
  role          = var.lab_role
  memory_size   = 2048
  environment {
    variables = {
      "TARGET_DB" = "${var.db_engine_sqlalchemy}://${var.db_username}:${var.db_password}@${aws_db_instance.postgresdb.endpoint}/${var.db_name}"
      "BUCKET_NAME" = "${aws_s3_bucket.data.bucket}"
      "OBJECT_KEY" = "data.sqlite"
    }
  }
}

resource "aws_lambda_function_event_invoke_config" "create_tables-invoke-config" {
  function_name                = aws_lambda_function.create_tables.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_lambda_function" "api-db" {
  image_uri    = docker_registry_image.api-db.name
  package_type = "Image"
  timeout      = 45
  vpc_config {
    security_group_ids = ["${aws_security_group.api-db-security-group.id}"]
    subnet_ids         = [aws_subnet.private-subnet-az1.id, aws_subnet.private-subnet-az2.id]
  }
  function_name = "api_db"
  role          = var.lab_role
  memory_size   = 1024
  environment {
    variables = {
      "TARGET_DB" = "${var.db_engine_sqlalchemy}://${var.db_username}:${var.db_password}@${aws_db_instance.postgresdb.endpoint}/${var.db_name}"
    }
  }
}

resource "aws_lambda_permission" "api-gw" {
  statement_id  = "AllowAPIgatewayInvokation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api-db.function_name
  principal     = "apigateway.amazonaws.com"
}