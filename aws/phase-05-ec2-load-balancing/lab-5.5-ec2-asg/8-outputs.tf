output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the ALB (for Route 53 alias records)"
  value       = module.alb.zone_id
}

output "app_url" {
  description = "Public HTTPS URL served by the ALB"
  value       = "https://www.${var.domain_name}"
}

output "domain_name" {
  description = "FQDN configured on the ALB"
  value       = var.domain_name
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate attached to the HTTPS listener"
  value       = local.certificate_arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.autoscaling.autoscaling_group_name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = module.autoscaling.autoscaling_group_arn
}

output "launch_template_id" {
  description = "ID of the launch template used by the ASG"
  value       = module.autoscaling.launch_template_id
}
