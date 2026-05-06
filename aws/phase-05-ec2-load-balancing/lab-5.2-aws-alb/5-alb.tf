# ----------------------------------------------------------------------------
# Application Load Balancer (HTTP only)
# ----------------------------------------------------------------------------
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.13.0"

  name               = "${var.environment}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_sg.security_group_id]

  create_security_group = false
  enable_deletion_protection = false

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "web-tg"
      }
    }
  }

  target_groups = {
    web-tg = {
      name_prefix       = "web-"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      create_attachment = false

      health_check = {
        enabled             = true
        path                = "/health"
        protocol            = "HTTP"
        port                = "traffic-port"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
