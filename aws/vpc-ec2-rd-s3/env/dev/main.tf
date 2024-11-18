terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source                    = "../../modules/vpc"
  environment               = var.environment
  vpc_cidr_block            = var.vpc_cidr_block
  vpc_name                  = var.vpc_name
  public_subnet_az1         = var.public_subnet_az1
  public_subnet_az2         = var.public_subnet_az2
  private_subnet_az1        = var.private_subnet_az1
  private_subnet_az2        = var.private_subnet_az2
}
module "nat_gateway" {
  source             = "../../modules/nat-gw"
  ym_vpc_id          = module.vpc.ym_vpc_id
  environment        = var.environment
  internet_gateway   = module.vpc.internet_gateway
  public_subnet_az1  = module.vpc.public_subnet_az1
  private_subnet_az1 = module.vpc.private_subnet_az1
  private_subnet_az2 = module.vpc.private_subnet_az2
}

