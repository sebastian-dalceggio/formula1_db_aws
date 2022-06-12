output "api_url" {
  value = aws_api_gateway_stage.api-db-stage.invoke_url
}

output "sever_ip" {
  value = aws_instance.admin-server.public_ip
}