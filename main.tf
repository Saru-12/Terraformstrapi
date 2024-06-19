provider "aws" {
  region = "us-west-1" # specify your region
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi_sg12"
  description = "Allow HTTP, HTTPS, and Strapi ports"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Strapi"
    from_port   = 1337
    to_port     = 1337
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

resource "aws_instance" "strapi" {
  ami           = "ami-08012c0a9ee8e21c4" # specify your desired AMI
  instance_type = "t2.micro"              # specify your desired instance type

  security_groups = [aws_security_group.strapi_sg.name]

  tags = {
    Name = "StrapiServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nodejs npm git
              sudo npm install -g pm2
              sudo mkdir -p /srv/strapi
              cd /srv/strapi
              sudo git clone https://github.com/strapi/strapi.git .
              sudo npm install
              pm2 start npm --name "strapi" -- start
              EOF

  key_name = var.key_name
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}

output "instance_public_ip" {
  value = aws_instance.strapi.public_ip
}
