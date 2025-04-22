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


resource "aws_instance" "app_server" {
  ami           = "ami-0e449927258d45bc4"  #published 04/11/2025
  instance_type = "t2.micro"               # Free tier eligible // for now 
  key_name      = "my_ec2_key"      
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # User data: Install Docker and run your container
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo systemctl start docker
              sudo usermod -a -G docker ec2-user
              # Pull and run container
              docker run -d --restart unless-stopped -it -p 3000:8989 sawayama-solitaire
              EOF



# need security group and subnets? maybe?
