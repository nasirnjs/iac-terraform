# modules/vpc/main.tf

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  # 2 Availability Zones (recommended for EKS)
  azs = var.azs

  # Exactly 2 public and 2 private subnets
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  # Enable Internet Gateway for public subnets
  create_igw = true

  # NAT Gateway configuration for private subnets
  enable_nat_gateway     = true
  single_nat_gateway     = true      # One NAT Gateway (cost-effective for dev/stage)
  one_nat_gateway_per_az = false     # Set to true in prod if you want HA

  # Important for EKS
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags for Kubernetes (EKS will automatically discover these)
  public_subnet_tags = {
    "kubernetes.io/role/alb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-alb" = "1"
  }
  public_route_table_tags = {
    Name = "${var.vpc_name}-public-rt"
  }

  private_route_table_tags = {
    Name = "${var.vpc_name}-private-rt"
  }

  igw_tags = {
    Name = "${var.vpc_name}-igw"
  }

  nat_gateway_tags = {
    Name = "${var.vpc_name}-nat"
  }

  tags = var.tags
}