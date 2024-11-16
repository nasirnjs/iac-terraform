resource "aws_vpc" "ec2_rds" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name        = format("%s-vpc", var.environment)
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "ec2_rds" {
  vpc_id = aws_vpc.ec2_rds.id
  tags = {
    Name        = format("%s-igw", var.environment)
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.ec2_rds.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name        = format("%s-public-subnet", var.environment)
    Environment = var.environment
  }
}

# Fetch availability zones dynamically based on the region
data "aws_availability_zones" "available" {}

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
