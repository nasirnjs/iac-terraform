provider "aws" {
  region = var.region
}
# ----------------------------
# VPC Module
# ----------------------------
module "vpc" {
    source = "../../modules/vpc"
    vpc_name             = var.vpc_name
    vpc_cidr             = var.vpc_cidr
    azs                  = var.azs
    public_subnet_cidrs  = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    tags                 = var.tags

}
# ----------------------------
# EKS Module
# ----------------------------
module "eks" {
  source  = "../../modules/eks"
  name       = var.name
  kubernetes_version = var.kubernetes_version
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  enable_public_endpoint = true
  node_group_name   = var.node_group_name
  node_instance_types = var.node_instance_types
  node_min            = 1
  node_max            = 3
  node_desired        = 1
  key_name        = var.key_name
  tags = {
    Environment = "dev"
  }
}
module "bastion" {
  source = "../../modules/bastion-host"

  name             = var.name
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets[0]
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
}