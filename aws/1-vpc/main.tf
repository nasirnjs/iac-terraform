resource "aws_vpc" "ym_vpc" {
  cidr_block        = var.vpc_cidr_block
  instance_tenancy  = "default"

  tags = {
    Name            = format("%s-ym_vpc", var.environment)
    Environment     = var.environment
  }
}

# aws_internet_gateway
resource "aws_internet_gateway" "ym_igw" {
  vpc_id            = aws_vpc.ym_vpc.id

  tags = {
    Name            = format("%s-ym_igw", var.environment)
    Environment     = var.environment
  }
}

# fetch availability zones dynamically based on the region
data "aws_availability_zones" "available" {}

# aws_public_subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.ym_vpc.id
  cidr_block        = var.public_subnet_az1
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name            = format("%s-pub_sub_az1", var.environment)
    Environment     = var.environment
  }
}
resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.ym_vpc.id
  cidr_block        = var.public_subnet_az2
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name            = format("%s-pub_sub_az2", var.environment)
    Environment     = var.environment
  }
}

# aws_public route_table
resource "aws_route_table" "public_sub_rt" {
  vpc_id            = aws_vpc.ym_vpc.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.ym_igw.id
  }
  tags = {
    Name            = format("%s-public_subnet_rt", var.environment)
    Environment     = var.environment
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id         = aws_subnet.public_subnet_az1.id
  route_table_id    = aws_route_table.public_sub_rt.id
}
# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id         = aws_subnet.public_subnet_az2.id
  route_table_id    = aws_route_table.public_sub_rt.id
}

# aws_private_subnet
resource "aws_subnet" "private_subnet_az1" {
  vpc_id            = aws_vpc.ym_vpc.id
  cidr_block        = var.private_subnet_az1
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name            = format("%s-private_sub_az1", var.environment)
    Environment     = var.environment
  }
}
resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.ym_vpc.id
  cidr_block        = var.private_subnet_az2
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name            = format("%s-private_sub_az2", var.environment)
    Environment     = var.environment
  }
}
# eip
resource "aws_eip" "ym_nat_eip" {
  domain       = "vpc"
  depends_on = [ aws_internet_gateway.ym_igw ]
  tags = {
    Name       = format("%s-nat_eip", var.environment)
    
  }
}

# nat
resource "aws_nat_gateway" "ym_nat_gw" {
  allocation_id = aws_eip.ym_nat_eip.id
  subnet_id     = aws_subnet.private_subnet_az1.id

  tags = {
    Name       = format("%s-nat_gw", var.environment)
    
  }
  depends_on = [aws_internet_gateway.ym_igw,aws_eip.ym_nat_eip]
}

#Private RT
resource "aws_route_table" "ym_subnet_private_rt" {
  vpc_id = aws_vpc.ym_vpc.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ym_nat_gw.id
  }

  tags = {
    Name       = format("%s-private_subnet_rt", var.environment)
    
  }
  depends_on = [aws_internet_gateway.ym_igw, aws_nat_gateway.ym_nat_gw]
}
# associate private subnet az1 to "private route table"
resource "aws_route_table_association" "ym_subnet_private_rt_association1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.ym_subnet_private_rt.id
  depends_on = [aws_route_table.ym_subnet_private_rt, aws_subnet.private_subnet_az1]
}
# associate private subnet az2 to "private route table"
resource "aws_route_table_association" "ym_subnet_private_rt_association2" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.ym_subnet_private_rt.id

  depends_on = [aws_route_table.ym_subnet_private_rt, aws_subnet.private_subnet_az2]
}