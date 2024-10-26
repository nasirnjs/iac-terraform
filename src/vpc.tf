module "vpc" {
  source = "../modules/vpc"

  vpc_cidr_block        = local.vpc-cidr
  domain_name           = local.vpc-domain
  public_subnets        = local.public-subnets
  private_subnets       = local.private-subnets
  enable_secondary_cidr = local.enable-secondary-cidr

  project_info = [
    local.env,
    local.developer,
  ]
}