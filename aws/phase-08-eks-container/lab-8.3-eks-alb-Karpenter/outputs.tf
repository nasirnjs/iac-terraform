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

output "karpenter_queue_name" {
  description = "SQS queue Karpenter uses for spot/interruption events"
  value       = module.karpenter.queue_name
}

output "karpenter_node_iam_role_arn" {
  description = "IAM role assumed by EC2 instances Karpenter provisions"
  value       = module.karpenter.node_iam_role_arn
}