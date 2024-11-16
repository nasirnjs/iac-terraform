output "vpc_id" {
  value = aws_vpc.ec2_rds.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_one_id" {
  value = aws_subnet.private_one.id
}

output "private_subnet_two_id" {
  value = aws_subnet.private_two.id
}
