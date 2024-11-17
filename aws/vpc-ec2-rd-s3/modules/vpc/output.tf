output "vpc_id" {
  value = aws_vpc.ym_vpc.id
}
output "public_subnet_az1" {
  value = aws_subnet.public_subnet_az1
}
output "public_subnet_az2" {
  value = aws_subnet.public_subnet_az2
}
output "private_subnet_az1" {
  value = aws_subnet.private_subnet_az1
}
output "private_subnet_az2" {
  value = aws_subnet.private_subnet_az2
}
output "public_internet_gateway" {
  value = aws_internet_gateway.ym_igw.id
  
}