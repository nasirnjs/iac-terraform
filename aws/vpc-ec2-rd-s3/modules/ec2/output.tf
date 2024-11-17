output "Instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
output "Instance_public_dns" {
  value = aws_instance.web_server.public_dns
}