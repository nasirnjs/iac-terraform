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
module "security_group" {
    source = "../../modules/security_group"
    environment                 = var.environment
    vpc_id                      = module.vpc.vpc_id
}
module "redis" {
    source = "../../modules/redis"
    environment       = var.environment
    redis_sg_ids      = module.security_group.redis_sg_ids
    vpc_id       = module.vpc.vpc_id
    private_subnet_az1 = module.vpc.private_subnet_az1
    private_subnet_az2 = module.vpc.private_subnet_az2
}


