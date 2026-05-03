data "aws_caller_identity" "current" {}

module "devops_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "6.6.0"

  name = "nasir.devops"

  force_destroy           = true
  password_reset_required = false
  create_login_profile = true
  create_access_key    = true

}

module "devops_group" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group"
  version = "6.6.0"

  name  = "devops-readonly"
  users = [module.devops_user.name]

  policies = {
    S3   = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    EC2  = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  }
}