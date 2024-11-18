output "ym_eip" {
    value = aws_eip.ym_eip.id 
}
output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw_az1
}
