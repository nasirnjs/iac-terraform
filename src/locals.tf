locals {

  env = terraform.workspace

  developer = "alamin"

  vpc_domains = {
    dev  = "dev.${local.developer}.com"
    uat  = "uat.${local.developer}.com"
    prod = "prod.${local.developer}.com"
  }
  vpc-domain = lookup(local.vpc_domains, local.env)

  vpc_cidr_blocks = {
    dev  = "10.20.0.0/20"
    uat  = "10.20.32.0/20"
    prod = "10.20.48.0/20"
  }
  vpc-cidr = lookup(local.vpc_cidr_blocks, local.env)

  public_subnets = {
    dev = {
      "10.20.0.0/24" = { az = "a" }
      "10.20.1.0/24" = { az = "b" }
      "10.20.2.0/24" = { az = "c" }
    }
    uat = {
      "10.20.32.0/24" = { az = "a" }
      "10.20.33.0/24" = { az = "b" }
      "10.20.34.0/24" = { az = "c" }
    }
    prod = {
      "10.20.48.0/24" = { az = "a" }
      "10.20.49.0/24" = { az = "b" }
      "10.20.50.0/24" = { az = "c" }
    }
  }
  public-subnets = lookup(local.public_subnets, local.env)

  private_subnets = {
    dev = {
      "10.20.8.0/24"  = { az = "a" }
      "10.20.9.0/24"  = { az = "b" }
      "10.20.10.0/24" = { az = "c" }
    }
    uat = {
      "10.20.40.0/24" = { az = "a" }
      "10.20.41.0/24" = { az = "b" }
      "10.20.42.0/24" = { az = "c" }
    }
    prod = {
      "10.20.55.0/24" = { az = "a" }
      "10.20.56.0/24" = { az = "b" }
      "10.20.57.0/24" = { az = "c" }
    }
  }
  private-subnets = lookup(local.private_subnets, local.env)

  enable_secondary_cidr = {
    dev  = false
    uat  = false
    prod = false
  }
  enable-secondary-cidr = local.enable_secondary_cidr[local.env]

}