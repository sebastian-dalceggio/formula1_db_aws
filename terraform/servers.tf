data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_instance" "admin_server" {
  ami               = "ami-0c4f7023847b90238"
  instance_type     = "t2.micro"
  availability_zone = var.availability_zones[0]
  key_name          = var.key_name
  tags = {
    Name = "admin_server"
  }
  vpc_security_group_ids = ["${aws_security_group.ssh_security_group.id}"]
  subnet_id              = aws_subnet.public_subnets[0].id
  user_data              = data.template_file.user_data.rendered
}