
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"
  
  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs = var.availability_zones

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  public_subnet_tags = {
    Name = "${var.vpc_name}-public"
  }

  private_subnet_tags = {
    Name = "${var.vpc_name}-private"
  }
  # NAT Gateway
  nat_gateway_tags = {
    Name = "${var.environment}-nat-gateway"
  }

  # Internet Gateway
  igw_tags = {
    Name = "${var.environment}-internet-gateway"
  }

  # Public Route Table
  public_route_table_tags = {
    Name = "${var.environment}-public-route-table"
  }

  # Private Route Table(s)
  private_route_table_tags = {
    Name = "${var.environment}-private-route-table"
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }

}