resource "aws_internet_gateway" "gw_main" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "Main gateway"
  }
}