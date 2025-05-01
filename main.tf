resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "app_sg" {
  vpc_id      = aws_vpc.main.id  # Make sure the security group is in the same VPC
  name        = "app-security-group"
  description = "Allow HTTP inbound traffic and all outbound traffic"

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 3000
    to_port     = 3000
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
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id  # Ensure the subnet is in the same VPC
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0e449927258d45bc4"
  instance_type           = "t2.micro"
  key_name               = "my_ec2_key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  subnet_id              = aws_subnet.public_subnet.id  # Reference the same subnet

  associate_public_ip_address = true

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