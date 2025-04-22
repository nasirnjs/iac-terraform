terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias = "virginia"
}


data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway       = true
  single_nat_gateway       = true
  one_nat_gateway_per_az   = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"          = var.cluster_name
  }
}

# EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  bootstrap_self_managed_addons = false

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    karpenter = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.large"]
      min_size       = 1
      max_size       = 10
      desired_size   = 1
    }
  }

  node_security_group_tags = {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = var.cluster_name
  }
}

module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name = module.eks.cluster_name

  enable_v1_permissions = true

  enable_pod_identity             = true
  create_pod_identity_association = true

  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
resource "helm_release" "karpenter" {
  namespace           = "kube-system"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "1.0.0"
  wait                = false

  values = [
    <<-EOT
    serviceAccount:
      name: karpenter-sa
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueue: "karpenter-interruption-queue"
    EOT
  ]
}



# Karpenter Kubectl
###############################################################################
# resource "kubectl_manifest" "karpenter_node_pool" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.sh/v1beta1
#     kind: NodePool
#     metadata:
#       name: default
#     spec:
#       template:
#         spec:
#           nodeClassRef:
#             name: default
#           requirements:
#             - key: "karpenter.k8s.aws/instance-category"
#               operator: In
#               values: ["c", "m", "r"]
#             - key: "karpenter.k8s.aws/instance-cpu"
#               operator: In
#               values: ["4", "8", "16", "32"]
#             - key: "karpenter.k8s.aws/instance-hypervisor"
#               operator: In
#               values: ["nitro"]
#             - key: "karpenter.k8s.aws/instance-generation"
#               operator: Gt
#               values: ["2"]
#       limits:
#         cpu: 1000
#       disruption:
#         consolidationPolicy: WhenEmpty
#         consolidateAfter: 30s
#   YAML

#   depends_on = [
#     kubectl_manifest.karpenter_node_class
#   ]
# }

# resource "kubectl_manifest" "karpenter_node_class" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.k8s.aws/v1beta1
#     kind: EC2NodeClass
#     metadata:
#       name: default
#     spec:
#       amiFamily: AL2023
#       role: ${module.karpenter.node_iam_role_name}
#       subnetSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: ${module.eks.cluster_name}
#       securityGroupSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: ${module.eks.cluster_name}
#       tags:
#         karpenter.sh/discovery: ${module.eks.cluster_name}
#   YAML

#   depends_on = [
#     helm_release.karpenter
#   ]
# }
