terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# terraform-state-locking
terraform {
    backend "s3" {
        bucket = "yourmentors-tfstates-bucket"
        key    = "buddy/dev/terraform.tfstate"
        region     = "us-east-2"
        dynamodb_table = "yourmentors-tfstates-locking"
        encrypt        = true
    }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
module "vpc" {
    source = "../../modules/vpc"
    cluster_name = var.cluster_name
    created_by = var.created_by
    aws_region = var.aws_region
    vpc_cidr_block = var.vpc_cidr_block
    subnet_private_1_cidr = var.subnet_private_1_cidr
    subnet_private_2_cidr = var.subnet_private_2_cidr
    subnet_public_1_cidr = var.subnet_public_1_cidr
    subnet_public_2_cidr = var.subnet_public_2_cidr

}

module "bastion_host" {
  source                = "../../modules/bastion-host"
  cluster_name          = var.cluster_name
  created_by            = var.created_by
  aws_region            = var.aws_region
  bastion_host_ec2_size = var.bastion_host_ec2_size
  bh_vpc                = module.vpc.vpc_name
  bh_subnet             = module.vpc.subnet_id-public_1.id
  ami_id                = var.ami_id
}

module "eks" {
  source = "../../modules/eks"
  aws_region              = var.aws_region
  vpc_cidr_block          = module.vpc.vpc_cidr_block
  cluster_name            = var.cluster_name
  created_by              = var.created_by
  subnet_id_private_1     = module.vpc.subnet_private_1.id
  subnet_id_private_2     = module.vpc.subnet_private_2.id
  node_group_desired_size = var.node_group_desired_size
  node_group_min_size     = var.node_group_min_size
  node_group_max_size     = var.node_group_max_size
  max_unavailable         = var.max_unavailable
  capacity_type           = var.capacity_type
  instance_types          = var.instance_types
  bastion_host_role_arn   = module.bastion_host.bh_role.arn
  aws_sg_ssh              = module.bastion_host.aws_sg_ssh
  bh_vpc_id               = module.vpc.vpc_id
}
