# ----------------------------------------------------------------------------
# Route 53 — lookup existing hosted zone and create alias records to the ALB
# ----------------------------------------------------------------------------
data "aws_route53_zone" "this" {
  name         = var.route53_zone_name
  private_zone = false
}

module "route53" {
  source  = "terraform-aws-modules/route53/aws"
  version = "6.5.0"

  create_zone = false
  name        = var.route53_zone_name

  records = {
    for fqdn in concat([var.domain_name], var.subject_alternative_names) :
    fqdn => {
      type      = "A"
      full_name = fqdn
      alias = {
        name                   = module.alb.dns_name
        zone_id                = module.alb.zone_id
        evaluate_target_health = true
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
