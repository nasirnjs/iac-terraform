module "eks_example_karpenter" {
  source  = "terraform-aws-modules/eks/aws//examples/karpenter"
  version = "20.36.0"
}


data "aws_availability_zones" "azs" {}