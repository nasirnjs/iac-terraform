terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# VPC Module
module "vpc" {
  source                         = "../../modules/vpc"
  environment                    = var.environment
  vpc_cidr_block                 = var.vpc_cidr_block
  public_subnet_cidr_block       = var.public_subnet_cidr_block
  private_subnet_cidr_blocks_one = var.private_subnet_cidr_blocks_one
  private_subnet_cidr_blocks_two = var.private_subnet_cidr_blocks_two
}

module "security_group" {
  source                  = "../../modules/security_group"
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  public_subnet_id        = module.vpc.public_subnet_id
  private_subnet_one_id   = module.vpc.private_subnet_one_id
  private_subnet_two_id   = module.vpc.private_subnet_two_id
}


module "ec2" {
  source       = "../../modules/ec2"
  environment  = var.environment
  instance_type = var.instance_type
  subnet_id    = module.vpc.public_subnet_id
  sg_id        = module.security_group.ec2_sg_id
}

module "rds" {
  source               = "../../modules/rds"
  environment          = var.environment
  instance_class       = var.db_instance_class
  db_user_name         = var.db_user_name
  db_password          = var.db_password
  db_name              = var.db_name
  rds_sg_id            = module.security_group.rds_sg_id
  private_subnet_one_id = module.vpc.private_subnet_one_id
  private_subnet_two_id = module.vpc.private_subnet_two_id
}