data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_instance" "admin-server" {
  ami               = "ami-0c4f7023847b90238"
  instance_type     = "t2.micro"
  availability_zone = var.availability_zones[0]
  key_name          = var.key_name
  tags = {
    Name = "internal-server"
  }
  # vpc_security_group_ids = ["${aws_security_group.ssh-security-group.id}", "${aws_security_group.database-security-group.id}"]
  vpc_security_group_ids = ["${aws_security_group.ssh-security-group.id}"]
  subnet_id              = aws_subnet.public_subnets[0].id
  user_data              = data.template_file.user_data.rendered
  # user_data = <<-EOF
  #                   #!/bin/bash
  #                   sudo apt-get update -y
  #                   sudo apt-get install \
  #                   ca-certificates \
  #                   curl \
  #                   gnupg \
  #                   postgresql-client-common \
  #                   postgresql-client-12 \
  #                   lsb-release -y
  #                   EOF
}