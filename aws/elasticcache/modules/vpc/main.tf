resource "aws_vpc" "web_rds_db" {
  cidr_block        = var.vpc_cidr_block
  instance_tenancy  = "default"

  tags = {
    Name            = format("%s_web_rds_db", var.environment)
    Environment     = var.environment
  }
}

# aws_internet_gateway
resource "aws_internet_gateway" "web_igw" {
  vpc_id            = aws_vpc.web_rds_db.id

  tags = {
    Name            = format("%s_web_igw", var.environment)
    Environment     = var.environment
  }
}

# fetch availability zones dynamically based on the region
data "aws_availability_zones" "available" {}

# aws_public_subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.web_rds_db.id
  cidr_block        = var.public_subnet_az1
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name            = format("%s_pub_sub_az1", var.environment)
    Environment     = var.environment
  }
}
resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.web_rds_db.id
  cidr_block        = var.public_subnet_az2
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name            = format("%s_pub_sub_az2", var.environment)
    Environment     = var.environment
  }
}

# aws_route_table
resource "aws_route_table" "public_sub_rt" {
  vpc_id            = aws_vpc.web_rds_db.id
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.web_igw.id
  }
  tags = {
    Name            = format("%s_public_subnet_rt", var.environment)
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
  vpc_id            = aws_vpc.web_rds_db.id
  cidr_block        = var.private_subnet_az1
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name            = format("%s_private_sub_az1", var.environment)
    Environment     = var.environment
  }
}
resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.web_rds_db.id
  cidr_block        = var.private_subnet_az2
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name            = format("%s_private_sub_az2", var.environment)
    Environment     = var.environment
  }
}
