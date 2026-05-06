# ----------------------------------------------------------------------------
# Classic Load Balancer (Layer 4/7 — legacy ELB)
# ----------------------------------------------------------------------------
resource "aws_elb" "web" {
  name            = "${var.environment}-clb"
  subnets         = module.vpc.public_subnets
  security_groups = [module.clb_sg.security_group_id]
  internal        = false

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = module.ec2_instance[*].id

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60

  tags = {
    Name        = "${var.environment}-clb"
    Terraform   = "true"
    Environment = var.environment
  }
}
