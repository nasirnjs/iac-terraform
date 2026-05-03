
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
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

module "web_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}


module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = var.ec2_name
  ami                         = var.ami
  create_security_group       = false
  vpc_security_group_ids      = [module.web_service_sg.security_group_id]
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = true
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}