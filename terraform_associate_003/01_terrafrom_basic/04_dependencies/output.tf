# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.example_vpc.id
  description = "The ID of the created VPC"
}

# Output the Subnet ID
output "subnet_id" {
  value = aws_subnet.example_subnet.id
  description = "The ID of the created Subnet"
}

# Output the Security Group ID
output "security_group_id" {
  value = aws_security_group.example_sg.id
  description = "The ID of the created Security Group"
}