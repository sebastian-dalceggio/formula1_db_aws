variable "key_name" {
  default = "vockey"
  type    = string
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
  type    = list(string)
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

variable "region" {
  default = "us-east-1"
  type    = string
}

variable "db_name" {
  default = "formula1_db"
  type    = string
}

variable "db_username" {
  default = "dbadmin"
  type    = string
}

variable "db_password" {
  default = "password"
  type    = string
}

variable "db_engine" {
  default = "postgres"
  type    = string
}

variable "db_engine_sqlalchemy" {
  default = "postgresql"
  type    = string
}

variable "create_tables_tag" {
  default = "1.0"
  type    = string
}

variable "load_data_tag" {
  default = "1.0"
  type    = string
}

variable "api_tag" {
  default = "1.0"
  type    = string
}

variable "lab_role" {
  default = "arn:aws:iam::003745103673:role/LabRole"
  type    = string
}