# ----------------------------------------------------------------------------
# ALB Security Group — public ingress on 80
# ----------------------------------------------------------------------------
module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "${var.environment}-alb-sg"
  description = "Security group for the public ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------
# Web instance Security Group — only ALB can reach port 80; SSH from anywhere
# ----------------------------------------------------------------------------
module "web_service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "${var.environment}-web-sg"
  description = "Security group for web instances behind the ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
