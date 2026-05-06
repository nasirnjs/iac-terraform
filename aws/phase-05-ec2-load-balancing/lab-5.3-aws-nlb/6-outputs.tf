output "nlb_dns_name" {
  description = "Public DNS name of the NLB"
  value       = module.nlb.dns_name
}

output "nlb_zone_id" {
  description = "Hosted zone ID of the NLB (for Route 53 alias records)"
  value       = module.nlb.zone_id
}

output "app_url" {
  description = "Public URL served by the NLB"
  value       = "http://${module.nlb.dns_name}"
}

output "web_instance_ids" {
  description = "IDs of the web EC2 instances behind the NLB"
  value       = module.ec2_instance[*].id
}

output "web_instance_private_ips" {
  description = "Private IPs of the web EC2 instances"
  value       = module.ec2_instance[*].private_ip
}
