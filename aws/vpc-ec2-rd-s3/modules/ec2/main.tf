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
  key_name = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data       = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx

              # Create index.html with H1 tag in the default NGINX web directory
              echo "<h1>Hello From Ubuntu EC2 Instance!!!</h1>" | sudo tee /var/www/html/index.html

              # Restart NGINX to apply the changes
              sudo systemctl restart nginx
              EOF
  #user_data = file("${path.module}/nginx_install.sh")

  tags = {
    Name        = format("%s-web-server", var.environment)
    Environment = var.environment
  }
}