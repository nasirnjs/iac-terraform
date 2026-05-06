output "clb_dns_name" {
  description = "Public DNS name of the CLB"
  value       = aws_elb.web.dns_name
}

output "clb_zone_id" {
  description = "Hosted zone ID of the CLB (for Route 53 alias records)"
  value       = aws_elb.web.zone_id
}

output "app_url" {
  description = "Public URL served by the CLB"
  value       = "http://${aws_elb.web.dns_name}"
}

output "web_instance_ids" {
  description = "IDs of the web EC2 instances behind the CLB"
  value       = module.ec2_instance[*].id
}

output "web_instance_private_ips" {
  description = "Private IPs of the web EC2 instances"
  value       = module.ec2_instance[*].private_ip
}
