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

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}