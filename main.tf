provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "strapi" {
  ami           = "ami-0cf2b4e024cdb6960"  
  instance_type = "t2.micro"

  tags = {
    Name = "StrapiInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nodejs npm git
              sudo npm install pm2@latest -g
              git clone https://github.com/PearlThoughts-DevOps-Internship/strapi.git /srv/strapi
              cd /srv/strapi
              npm install
              npm run build
              pm2 start npm --name "strapi" -- run start
              EOF
}
