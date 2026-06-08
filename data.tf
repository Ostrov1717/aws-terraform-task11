data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc]
  }
}

data "aws_subnet" "public1" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet1]
  }
}

data "aws_subnet" "public2" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet2]
  }
}

data "aws_security_group" "ssh_inbound" {
  filter {
    name   = "tag:Name"
    values = [var.ssh_inbound]
  }
}

data "aws_security_group" "http_inbound" {
  filter {
    name   = "tag:Name"
    values = [var.http_inbound]
  }
}

data "aws_security_group" "lb_http_inbound" {
  filter {
    name   = "tag:Name"
    values = [var.lb_http_inbound]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
