module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.20.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access                   = true
  endpoint_public_access_cidrs             = var.public_access_cidrs
  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      name           = "eks-worker-group"
      instance_types = var.node_instance_types
      ami_type       = var.node_group_ami_type
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
    }
  }

  # Tag the cluster security group so Karpenter can auto-discover it.
  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
