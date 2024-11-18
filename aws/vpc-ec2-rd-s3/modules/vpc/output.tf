output "ym_vpc_id" {
  value = aws_vpc.ym_vpc.id
}
output "public_subnet_az1" {
  value = aws_subnet.public_subnet_az1.id
}
output "public_subnet_az2" {
  value = aws_subnet.public_subnet_az2.id
}
output "private_subnet_az1" {
  value = aws_subnet.private_subnet_az1.id
}
output "private_subnet_az2" {
  value = aws_subnet.private_subnet_az2.id
}
output "internet_gateway" {
  value = aws_internet_gateway.ym_igw.id
}
