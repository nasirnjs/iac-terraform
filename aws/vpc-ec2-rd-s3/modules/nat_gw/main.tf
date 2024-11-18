# Elastic IP for NAT Gateway
resource "aws_eip" "ym_eip" {
  tags = {
    Name = format("%s-nat_eip", var.environment)
    Environment = var.environment
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw_az1" {
  allocation_id = aws_eip.ym_eip.id
  subnet_id     = var.public_subnet_az1
  tags = {
    Name = format("%s-nat_gw", var.environment)
    Environment = var.environment
  }
}


# Route Table for Private Subnets
resource "aws_route_table" "private_sub_az1_rt" {
  vpc_id = var.ym_vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_az1.id
  }

  tags = {
    Name        = format("%s-private_subnet_rt", var.environment)
    Environment = var.environment
  }
  depends_on = [ var.internet_gateway ]
}
resource "aws_route_table" "private_sub_az2_rt" {
  vpc_id = var.ym_vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_az1.id
  }

  tags = {
    Name        = format("%s-private_subnet_rt", var.environment)
    Environment = var.environment
  }
  depends_on = [ var.internet_gateway ]
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_az1_route_table_association" {
  subnet_id      = var.private_subnet_az1
  route_table_id = aws_route_table.private_sub_az1_rt.id
}

resource "aws_route_table_association" "private_subnet_az2_route_table_association" {
  subnet_id      = var.private_subnet_az2
  route_table_id = aws_route_table.private_sub_az2_rt.id
}

