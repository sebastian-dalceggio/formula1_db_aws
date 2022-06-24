resource "aws_s3_bucket" "data" {
  bucket        = "formula1-data"
  force_destroy = true
}

resource "aws_vpc_endpoint" "s3-endpoints" {
  vpc_id          = aws_vpc.vpc_main.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.private_route_table.id]
}