resource "aws_vpc" "ec2_rds" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name        = format("%s-vpc", var.environment)
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "ec2_rds_igw" {
  vpc_id = aws_vpc.ec2_rds.id
  tags = {
    Name        = format("%s-igw", var.environment)
    Environment = var.environment
  }
}

# Fetch availability zones dynamically based on the region
data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.ec2_rds.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name        = format("%s-public-subnet", var.environment)
    Environment = var.environment
  }
}

# Private Subnet One
resource "aws_subnet" "private_one" {
  vpc_id           = aws_vpc.ec2_rds.id
  cidr_block       = var.private_subnet_cidr_blocks_one[0]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name        = format("%s-private-subnet-one", var.environment)
    Environment = var.environment
  }
}

# Private Subnet Two
resource "aws_subnet" "private_two" {
  vpc_id           = aws_vpc.ec2_rds.id
  cidr_block       = var.private_subnet_cidr_blocks_two[0]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name        = format("%s-private-subnet-two", var.environment)
    Environment = var.environment
  }
}
# Create a Route Table for the public subnet
resource "aws_route_table" "ec2_rds_public_rt" {
  vpc_id = aws_vpc.ec2_rds.id

  # Route all traffic (0.0.0.0/0) through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_rds_igw.id
  }

  tags = {
    Name       = format("%s-public-rt", var.environment)
    Environment = var.environment
  }
}

# Associate the Route Table with the public subnet
resource "aws_route_table_association" "ec2_public_rt_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.ec2_rds_public_rt.id
}