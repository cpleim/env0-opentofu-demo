provider "aws" {
  region = "us-east-1"
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be deployed"
  type        = string
  default     = "subnet-05e9ef01c96adf41a"
}

variable "vpc_id" {
  description = "The ID of the VPC where the EC2 instance will be deployed"
  type        = string
  default     = "vpc-06908b3571b2e213a"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu_machine" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
  ]

  tags = {
    Name = "env0-opentofu-demo"
  }
}
