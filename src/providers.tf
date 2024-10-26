terraform {
  backend "s3" {
    bucket         = "dev-alamin-med-iac-state"
    key            = "keyfiles"
    region         = "us-west-2"
    dynamodb_table = "dev-alamin-med-iac-state"
  }
}

provider "aws" {
  region = "us-west-2"
}

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.endpoint
#     cluster_ca_certificate = base64decode(module.eks.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.medlify.token
#   }
# }
#
# provider "kubernetes" {
#   host                   = module.eks.endpoint
#   cluster_ca_certificate = base64decode(module.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.medlify.token
# }