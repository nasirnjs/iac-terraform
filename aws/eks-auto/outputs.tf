output "vpc_id" {
  value = aws_vpc.ym_vpc.id
}

output "subnet_private_1a_id" {
  value = aws_subnet.private_1a.id
}

output "subnet_private_1b_id" {
  value = aws_subnet.private_1b.id
}
