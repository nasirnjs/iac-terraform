output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the ALB (for Route 53 alias records)"
  value       = module.alb.zone_id
}

output "app_url" {
  description = "Public URL served by the ALB"
  value       = "http://${module.alb.dns_name}"
}

output "web_instance_ids" {
  description = "IDs of the web EC2 instances behind the ALB"
  value       = aws_instance.web[*].id
}

output "web_instance_private_ips" {
  description = "Private IPs of the web EC2 instances"
  value       = aws_instance.web[*].private_ip
}
