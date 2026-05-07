# ----------------------------------------------------------------------------
# ACM certificate (DNS-validated via Route 53). Skipped when an existing
# certificate ARN is provided via var.acm_certificate_arn.
# ----------------------------------------------------------------------------
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.3.0"

  count = var.create_acm_certificate ? 1 : 0

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.this.zone_id

  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  wait_for_validation = true

  tags = {
    Name        = var.domain_name
    Terraform   = "true"
    Environment = var.environment
  }
}
