terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# basic example using ami lookup https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

#configuration for AWS provider
provider "aws" {
  region = "us-east-1"
}

# setting up a security group to allow http traffic and allow all outgoing
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0e449927258d45bc4"  #published 04/11/2025
  instance_type = "t2.micro"               # Free tier eligible // for now 
  key_name      = "my_ec2_key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # User data: Install Docker and run container
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo systemctl start docker
              sudo usermod -a -G docker ec2-user
              # Pull and run container
              docker run -d --restart unless-stopped -it -p 3000:8989 sawayama-solitaire
              EOF
}

# need security group and subnets? maybe?
