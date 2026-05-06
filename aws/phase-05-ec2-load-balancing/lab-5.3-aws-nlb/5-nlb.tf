# ----------------------------------------------------------------------------
# Network Load Balancer (Layer 4 — TCP)
# ----------------------------------------------------------------------------
module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name               = "${var.environment}-nlb"
  load_balancer_type = "network"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.nlb_sg.security_group_id]

  create_security_group            = false
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  listeners = {
    tcp = {
      port     = 80
      protocol = "TCP"
      forward = {
        target_group_key = "web-tg"
      }
    }
  }

  target_groups = {
    web-tg = {
      name_prefix       = "web-"
      protocol          = "TCP"
      port              = 80
      target_type       = "instance"
      create_attachment = false

      health_check = {
        enabled             = true
        protocol            = "HTTP"
        path                = "/"
        port                = "traffic-port"
        matcher             = "200"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 3
        unhealthy_threshold = 3
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
