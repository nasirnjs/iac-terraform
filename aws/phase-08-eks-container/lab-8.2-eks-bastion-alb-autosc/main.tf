module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.18.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access                   = true
  endpoint_private_access                  = true
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

  # Grant the bastion IAM role cluster-admin via EKS access entry
  access_entries = {
    bastion = {
      principal_arn = module.bastion.iam_role_arn
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Allow the bastion to reach the EKS private API endpoint (HTTPS 443)
resource "aws_vpc_security_group_ingress_rule" "eks_api_from_bastion" {
  security_group_id            = module.eks.cluster_security_group_id
  referenced_security_group_id = aws_security_group.bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  description                  = "Bastion to EKS API"
}
