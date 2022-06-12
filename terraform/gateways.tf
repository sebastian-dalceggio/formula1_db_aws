resource "aws_internet_gateway" "gw-main" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = "gw-main"
  }
}