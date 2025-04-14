terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.12.2"

    }
  }
}

# basic example using ami lookup https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

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
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "temporary-tag?"
  }
}



# need security group and subnets? maybe?


# this has been pulled off of : https://registry.terraform.io/providers/cybershard/docker/latest/docs
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pulls the image
resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

# Create a container
resource "docker_container" "solitaire-gg" {
  image = docker_image.ubuntu.latest
  name  = "solitaire-gg"
}
