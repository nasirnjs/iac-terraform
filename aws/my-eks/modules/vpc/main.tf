
# VPC
resource "aws_vpc" "buddy_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name       = var.cluster_name
    created_by = var.created_by
  }
}

# IGW
resource "aws_internet_gateway" "buddy_igw" {
  vpc_id = aws_vpc.buddy_vpc.id
  tags = {
    Name       = format("%s igw", var.cluster_name)
    created_by = var.created_by
  }
  depends_on = [aws_vpc.buddy_vpc]

}
# private subnet 1
resource "aws_subnet" "buddy_subnet_private_zone1" {
  vpc_id            = aws_vpc.buddy_vpc.id
  cidr_block        = var.subnet_private-1_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name       = format("%s private_1", var.cluster_name)
    created_by = var.created_by

  }
  depends_on = [aws_vpc.buddy_vpc]
}

# private subnet 2
resource "aws_subnet" "buddy_subnet_private_zone2" {
  vpc_id            = aws_vpc.buddy_vpc.id
  cidr_block        = var.subnet_private-2_cidr
  availability_zone = "${var.aws_region}b"
  tags = {
    Name       = format("%s private_2", var.cluster_name)
    created_by = var.created_by

  }
  depends_on = [aws_vpc.buddy_vpc]
}

#public subnet 1
resource "aws_subnet" "buddy_subnet_public_zone1" {
  vpc_id            = aws_vpc.buddy_vpc.id
  cidr_block        = var.subnet_public-1_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name                        = format("%s public_1", var.cluster_name)
    #"kubernetes.io/role/elb"    = "1"
    created_by                  = var.created_by

  }
  depends_on = [aws_vpc.buddy_vpc]
}

#public subnet 2
resource "aws_subnet" "buddy_subnet_public_zone2" {
  vpc_id            = aws_vpc.buddy_vpc.id
  cidr_block        = var.subnet_public-2_cidr
  availability_zone = "${var.aws_region}b"
  tags = {
    Name                        = format("%s public_2", var.cluster_name)
    #"kubernetes.io/role/elb"    = "1"
    created_by                  = var.created_by

  }
  depends_on = [aws_vpc.buddy_vpc]
}

# elastic ip
resource "aws_eip" "buddy_nat_eip" {
  domain       = "vpc"
  depends_on = [ aws_internet_gateway.buddy_igw ]
  tags = {
    Name       = format("%s nat_eip", var.cluster_name)
    created_by = var.created_by
  }
}

# nat gateway
resource "aws_nat_gateway" "buddy_nat" {
  allocation_id = aws_eip.buddy_nat_eip.id
  subnet_id     = aws_subnet.buddy_subnet_public_zone1.id

  tags = {
    Name       = format("%s nat", var.cluster_name)
    created_by = var.created_by
  }
  depends_on = [aws_internet_gateway.buddy_igw,aws_eip.buddy_nat_eip]
}

# private route
resource "aws_route_table" "buddy_subnet_private_rt" {
  vpc_id = aws_vpc.buddy_vpc.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.buddy_nat.id
  }

  tags = {
    Name       = format("%s private_rt", var.cluster_name)
    created_by = var.created_by
  }
  depends_on = [aws_internet_gateway.buddy_igw,aws_nat_gateway.buddy_nat]
}

# public route
resource "aws_route_table" "buddy_subnet_public_rt" {
  vpc_id = aws_vpc.buddy_vpc.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.buddy_igw.id
  }

  tags = {
    Name       = format("%s public_rt", var.cluster_name)
    created_by = var.created_by
  }
  depends_on = [aws_internet_gateway.buddy_igw,aws_nat_gateway.buddy_nat]
}

# public route table association
resource "aws_route_table_association" "buddy_subnet_public_rt_association1" {
  subnet_id      = aws_subnet.buddy_subnet_public_zone1.id
  route_table_id = aws_route_table.buddy_subnet_public_rt.id
  depends_on     = [aws_route_table.buddy_subnet_public_rt,aws_subnet.buddy_subnet_public_zone1]
}

resource "aws_route_table_association" "buddy_subnet_public_rt_association2" {
  subnet_id      = aws_subnet.buddy_subnet_public_zone2.id
  route_table_id = aws_route_table.buddy_subnet_public_rt.id
  depends_on     = [aws_route_table.buddy_subnet_public_rt,aws_subnet.buddy_subnet_public_zone2]
}

# private route table association
resource "aws_route_table_association" "buddy_subnet_private_rt_association1" {
  subnet_id      = aws_subnet.buddy_subnet_private_zone1.id
  route_table_id = aws_route_table.buddy_subnet_private_rt.id
  depends_on = [aws_route_table.buddy_subnet_private_rt,aws_subnet.buddy_subnet_private_zone1]
}

resource "aws_route_table_association" "buddy_subnet_private_rt_association2" {
  subnet_id      = aws_subnet.buddy_subnet_private_zone2.id
  route_table_id = aws_route_table.buddy_subnet_private_rt.id
  depends_on = [aws_route_table.buddy_subnet_private_rt,aws_subnet.buddy_subnet_private_zone2]
}
