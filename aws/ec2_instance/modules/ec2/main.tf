resource "aws_instance" "web_instance" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = var.instance_type

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [var.sg_id]
  associate_public_ip_address = true

  tags = {
    Name        = format("%s-web-server", var.environment)
    Environment = var.environment
  }
}
