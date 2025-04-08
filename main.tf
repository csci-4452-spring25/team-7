terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

#configuration for AWS provider
provider "aws" {
  region = "us-west-1"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# Create an EC2 instance
resource "aws_instance" "solitaire" {
  ami           = data.aws_ami.ubuntu
  instance_type = "t3.micro"

  tags = {
    Name = "temporary-tag?"
  }
}

# need security group and subnets? maybe?
