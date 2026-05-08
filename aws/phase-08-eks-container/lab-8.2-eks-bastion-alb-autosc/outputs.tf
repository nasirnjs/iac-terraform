output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "bastion_instance_id" {
  description = "Bastion EC2 instance ID"
  value       = module.bastion.id
}

output "bastion_public_ip" {
  description = "Bastion public IP for SSH access"
  value       = module.bastion.public_ip
}

output "bastion_ssh_command" {
  description = "Command to SSH into the bastion"
  value       = "ssh -i ~/.ssh/${var.bastion_key_name}.pem ubuntu@${module.bastion.public_ip}"
}

output "bastion_ssm_connect_command" {
  description = "Backup access via SSM Session Manager"
  value       = "aws ssm start-session --region ${var.aws_region} --target ${module.bastion.id}"
}