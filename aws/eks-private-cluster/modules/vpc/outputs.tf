output "vpc_name" {
  description = "name of the VPC"
  value       = aws_vpc.quickops_vpc.id
}
output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.quickops_vpc.cidr_block
}

output "subnet_id_private_1" {
  value = aws_subnet.quickops_subnet_private_1
}

output "subnet_id_private_2" {
  value = aws_subnet.quickops_subnet_private_2
}

output "subnet_id_public_1" {
  value = aws_subnet.quickops_subnet_public_1
}

output "subnet_id_public_2" {
  value = aws_subnet.quickops_subnet_public_2
}