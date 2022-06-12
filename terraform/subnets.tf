resource "aws_subnet" "public-subnet-az1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public-subnet-az2" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 2"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc-main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-main.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public-subnet-az1-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-az1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-az2-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-az2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "private-subnet-az1" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private-subnet-az2" {
  cidr_block              = "10.0.3.0/24"
  vpc_id                  = aws_vpc.vpc-main.id
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet 2"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = "Private Route Table 1"
  }
}

resource "aws_route_table_association" "private-subnet-az1-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-az1.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-subnet-az2-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-az2.id
  route_table_id = aws_route_table.private-route-table.id
}