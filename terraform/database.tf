resource "aws_db_subnet_group" "database-subnet-group" {
  name        = "database subnets"
  subnet_ids  = [aws_subnet.private-subnet-az1.id, aws_subnet.private-subnet-az2.id]
  description = "Subnet for Database Instance"
  tags = {
    "Name" = "Database Subnets"
  }
}

resource "aws_db_instance" "postgresdb" {
  instance_class         = "db.t3.micro"
  allocated_storage      = 100
  engine                 = var.db_engine
  engine_version         = "12.7"
  skip_final_snapshot    = true
  availability_zone      = var.availability_zone_1
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  monitoring_interval    = 0
  storage_type           = "gp2"
  identifier             = "postgresdb"
}
