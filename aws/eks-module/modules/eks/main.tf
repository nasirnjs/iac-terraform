module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.16"

  name                = var.name
  kubernetes_version  = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  endpoint_public_access  = var.enable_public_endpoint
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  enable_irsa = true

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    "${var.node_group_name}" = {

      name           = var.node_group_name
      instance_types = var.node_instance_types

      min_size     = var.node_min
      max_size     = var.node_max
      desired_size = var.node_desired

      key_name = var.key_name

      create_iam_role          = true
      iam_role_name            = "${var.name}-${var.node_group_name}-ng-role"
      iam_role_use_name_prefix = false

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }
      tags = merge(var.tags, {
        "k8s.io/cluster-autoscaler/enabled"     = "true"
        "k8s.io/cluster-autoscaler/${var.name}" = "owned"
      })
    }
  }

  tags = var.tags
}