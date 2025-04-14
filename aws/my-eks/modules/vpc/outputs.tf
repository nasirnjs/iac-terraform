output "vpc_name" {
  value = aws_vpc.buddy_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.buddy_vpc.id
}

output "subnet_private_1" {
  value = aws_subnet.buddy_subnet_private_zone1
}
output "subnet_private_2" {
  value = aws_subnet.buddy_subnet_private_zone2
}

output "subnet_id-public_1" {
  value = aws_subnet.buddy_subnet_public_zone1
}

output "subnet-id-public_2" {
  value = aws_subnet.buddy_subnet_public_zone2
}
output "vpc_id" {
  value = aws_vpc.buddy_vpc.id
  description = "The ID of the VPC"
}
