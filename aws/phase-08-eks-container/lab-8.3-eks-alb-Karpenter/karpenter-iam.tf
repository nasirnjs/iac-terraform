
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "21.20.0"

  cluster_name = module.eks.cluster_name

  create_pod_identity_association = true
  namespace                       = var.karpenter_namespace
  service_account                 = "karpenter"

  node_iam_role_use_name_prefix = false
  node_iam_role_name            = "${var.cluster_name}-karpenter-node"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}


resource "aws_iam_service_linked_role" "spot" {
  count            = var.create_spot_service_linked_role ? 1 : 0
  aws_service_name = "spot.amazonaws.com"
  description      = "Service-linked role for EC2 Spot, required by Karpenter when provisioning spot capacity"
}
