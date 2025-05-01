provider "aws" {
  region = "us-east-1" # Change if needed
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in default VPC
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  id = tolist(data.aws_subnets.default_subnets.ids)[0]
}

# Security group for SSH and app port
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow SSH and app traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  description = "Allow HTTP from anywhere"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 Instance
resource "aws_instance" "app_server" {
  ami                         = "ami-0e449927258d45bc4" # Amazon Linux 2 (us-east-1)
  instance_type               = "t2.micro"
  key_name                    = "my_ec2_key" # Must exist in AWS
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
             #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              docker run -d --restart unless-stopped -p 3000:3000 sawayama-solitaire
              logout
              EOF 

  tags = {
    Name = "app-server"
  }
}

# Output public IP
output "public_ip" {
  value = aws_instance.app_server.public_ip
}

#update on secrets push
#final push
#final final final