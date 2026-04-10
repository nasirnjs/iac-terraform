# environments/dev/terraform.tfvars
project_name = "mist-eks"
region = "ap-south-1"
azs = ["ap-south-1a", "ap-south-1b"]
vpc_name = "mist-dev-eks-vpc"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
tags = {
  Project     = "mist-eks"
  Environment = "dev"
  ManagedBy   = "Terraform"
}

# EKS Module
name                   = "mist-eks-dev"
kubernetes_version     = "1.35"
enable_public_endpoint = true
node_group_name        = "mist-dev-eks-ng"
node_instance_types    = ["c5.xlarge"]
node_desired           = 1
node_min               = 1
node_max               = 3
key_name               = "nasir-mumbai-key"

# bastion-host
ami_id                = "ami-05d2d839d4f73aafb"
instance_type         = "t2.medium"
