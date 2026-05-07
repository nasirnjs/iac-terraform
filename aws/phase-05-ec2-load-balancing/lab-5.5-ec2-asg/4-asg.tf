module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.2.1"

  name            = "${var.environment}-web-asg"
  use_name_prefix = true

  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "ELB"
  health_check_grace_period = 300

  # Launch template
  create_launch_template          = true
  launch_template_name            = "${var.environment}-web"
  launch_template_use_name_prefix = true
  launch_template_description     = "Launch template for ${var.environment} web ASG"
  update_default_version          = true

  image_id          = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_groups   = [module.web_service_sg.security_group_id]
  enable_monitoring = true

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = var.root_disk_size
        volume_type           = "gp3"
        encrypted             = true
        delete_on_termination = true
      }
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Name        = "${var.environment}-web"
        Terraform   = "true"
        Environment = var.environment
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name        = "${var.environment}-web-volume"
        Terraform   = "true"
        Environment = var.environment
      }
    }
  ]

  # Attach to ALB target group created in 5-alb.tf
  traffic_source_attachments = {
    web = {
      traffic_source_identifier = module.alb.target_groups["web-tg"].arn
      traffic_source_type       = "elbv2"
    }
  }

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
  }

  scaling_policies = {
    cpu-target-tracking = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = var.asg_cpu_target
      }
    }
  }

  tags = {
    Name        = "${var.environment}-web"
    Terraform   = "true"
    Environment = var.environment
  }
}
