resource "aws_security_group" "ssh-security-group" {
  name        = "SSH Access"
  description = "Enable SSH access on Port 22"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "SSH Security Group"
  }

}

resource "aws_security_group" "http-security-group" {
  name        = "HTTP/HTTPS Access"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    cidr_blocks = [var.vpc_cidr_block]
    description = "HTTPS access"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  ingress {
    cidr_blocks = [var.vpc_cidr_block]
    description = "HTTP access"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    cidr_blocks = [var.vpc_cidr_block]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "HTTP/HTTPS Security Group"
  }

}

resource "aws_security_group" "database-security-group" {
  name        = "Database Security Group"
  description = "Enable Postgresql access on Port 5432"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    cidr_blocks = [var.vpc_cidr_block]
    description = "Postgresql access"
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
  }

  egress {
    cidr_blocks = [var.vpc_cidr_block]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "Database Security Group"
  }
}

resource "aws_security_group" "lambda-security-group" {
  name        = "Lambda Security Group"
  description = "Enable all access"
  vpc_id      = aws_vpc.vpc_main.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "Lambda Security Group"
  }
}

resource "aws_security_group" "api-db-security-group" {
  name        = "Api-db Security Group"
  description = "Enable all access"
  vpc_id      = aws_vpc.vpc_main.id

  egress {
    cidr_blocks = [var.vpc_cidr_block]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "Api-db Security Group"
  }
}