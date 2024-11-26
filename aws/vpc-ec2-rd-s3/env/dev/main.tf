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
  source             = "../../modules/nat_gw"
  ym_vpc_id          = module.vpc.ym_vpc_id
  environment        = var.environment
  internet_gateway   = module.vpc.internet_gateway
  public_subnet_az1  = module.vpc.public_subnet_az1
  private_subnet_az1 = module.vpc.private_subnet_az1
  private_subnet_az2 = module.vpc.private_subnet_az2
}
module "sec_group" {
  source = "../../modules/sec_group"
  ym_vpc_id = module.vpc.ym_vpc_id
  environment = var.environment
}
module "ec2" {
  source               = "../../modules/ec2"
  environment          = var.environment
  instance_type        = var.instance_type
  public_subnet_az1    = module.vpc.public_subnet_az1  
  alb_sg_id            = module.sec_group.alb_sg_id
  key_name             = var.key_name
}
module "aurora" {
  source      = "../../modules/aurora_mysql"
  environment = var.environment
  db_password = var.db_password
  private_subnet_az1 = module.vpc.private_subnet_az1
  private_subnet_az2 = module.vpc.private_subnet_az2
  vpc_security_group_ids = [module.sec_group.aurora_mysql_sg_id]
}
