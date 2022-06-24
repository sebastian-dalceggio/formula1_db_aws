resource "aws_db_subnet_group" "private_subnets_group" {
  name        = "private_subnets"
  subnet_ids  = aws_subnet.private_subnets[*].id
  description = "Private subnets group"
  tags = {
    Name = "Private subnets"
  }
}

resource "aws_db_instance" "postgresdb" {
  instance_class         = "db.t3.micro"
  allocated_storage      = 100
  engine                 = var.db_engine
  engine_version         = "12.7"
  skip_final_snapshot    = true
  availability_zone      = var.availability_zones[0]
  db_subnet_group_name   = aws_db_subnet_group.private_subnets_group.name
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  monitoring_interval    = 0
  storage_type           = "gp2"
  identifier             = "postgresdb"
}
