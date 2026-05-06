output "vpc_id" {
  value = aws_vpc.web_rds_db.id
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
  value = aws_internet_gateway.web_igw.id
}
