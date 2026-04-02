output "cluster_id" {
  description = "EKS Cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS Cluster security group ID"
  value       = module.eks.cluster_security_group_id
}
output "node_group_name" {
  description = "Name of the EKS managed node group"
  value       = var.node_group_name
}
output "node_group_role_arn" {
  description = "IAM role ARN for managed node group"
  value       = module.eks.eks_managed_node_groups[var.node_group_name].iam_role_arn
}