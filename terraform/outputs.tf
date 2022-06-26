output "api_url" {
  value = aws_api_gateway_stage.api_db_stage.invoke_url
}

output "sever_ip" {
  value = aws_instance.admin_server.public_ip
}