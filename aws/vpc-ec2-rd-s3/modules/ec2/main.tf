resource "aws_instance" "web_instance" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = var.instance_type

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  subnet_id               = var.public_subnet_az1
  vpc_security_group_ids  = [var.alb_sg_id]
  associate_public_ip_address = true

  user_data       = <<-EOF
                #!/bin/bash
                # Update package list
                apt-get update -y

                # Install Nginx
                sudo apt-get install -y nginx

                # Start the Nginx service
                sudo systemctl start nginx

                # Enable Nginx to start on boot
                sudo systemctl enable nginx

                # Allow HTTP traffic on port 80 in the firewall
                sudo ufw allow 'Nginx HTTP'

                # Restart Nginx to apply any changes
                sudo systemctl restart nginx
              EOF
  tags = {
    Name        = format("%s-web-server", var.environment)
    Environment = var.environment
  }

}