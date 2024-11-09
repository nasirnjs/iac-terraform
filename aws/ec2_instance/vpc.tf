# Create a VPC
resource "aws_vpc" "ec2_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = format("%s-vpc", var.environment)
    Environment = var.environment
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = aws_vpc.ec2_vpc.id
  tags = {
    Name       = format("%s-igw", var.environment)
    Environment = var.environment
  }
}

# Create a public subnet within the VPC
resource "aws_subnet" "ec2_public_subnet" {
  vpc_id                  = aws_vpc.ec2_vpc.id
  cidr_block              = var.subnet_cidr_block
  #map_public_ip_on_launch = true

  tags = {
    Name       = format("%s-public-subnet", var.environment)
    Environment = var.environment
  }
}

# Create a Route Table for the public subnet
resource "aws_route_table" "ec2_public_rt" {
  vpc_id = aws_vpc.ec2_vpc.id

  # Route all traffic (0.0.0.0/0) through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_igw.id
  }

  tags = {
    Name       = format("%s-public-rt", var.environment)
    Environment = var.environment
  }
}

# Associate the Route Table with the public subnet
resource "aws_route_table_association" "ec2_public_rt_association" {
  subnet_id      = aws_subnet.ec2_public_subnet.id
  route_table_id = aws_route_table.ec2_public_rt.id
}
