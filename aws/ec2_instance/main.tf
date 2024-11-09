# Create an EC2 instance
resource "aws_instance" "web_instance" {
  ami           = "ami-0866a3c8686eaeeba" 
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 20  
    volume_type = "gp2"
  }
  subnet_id = aws_subnet.ec2_public_subnet.id           
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name       = format("%s-web-server", var.environment)
    Environment = var.environment
  }
}
