resource "aws_instance" "web_server" {
  ami           = var.Instance_ami
  instance_type = var.instance_type

  tags = {
    Name = format("%s-web-server",var.environment)
    environment = env.environment
  }
}