provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow HTTP and SSH"
  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_instance" "app_server" {
  ami                    = "ami-0e449927258d45bc4"
  instance_type          = "t2.micro"
  key_name               = "my_ec2_key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user
    docker run -d --restart unless-stopped -p 3000:3000 sawayama-solitaire
  EOF

  tags = {
    Name = "app-server"
  }
}
