# ----------------------------------------------------------------------------
# Application Load Balancer with HTTP→HTTPS redirect and TLS termination
# ----------------------------------------------------------------------------
locals {
  certificate_arn = var.create_acm_certificate ? module.acm[0].acm_certificate_arn : var.acm_certificate_arn
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name               = "${var.environment}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_sg.security_group_id]

  create_security_group      = false
  enable_deletion_protection = false

  listeners = {
    http_redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn = local.certificate_arn

      forward = {
        target_group_key = "web-tg"
      }

      rules = {
        www_to_apex = {
          priority = 10
          actions = [{
            type = "redirect"
            redirect = {
              status_code = "HTTP_301"
              host        = var.domain_name
              path        = "/#{path}"
              query       = "#{query}"
              protocol    = "HTTPS"
              port        = "443"
            }
          }]
          conditions = [{
            host_header = {
              values = ["www.${var.domain_name}"]
            }
          }]
        }
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
        path                = "/"
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
