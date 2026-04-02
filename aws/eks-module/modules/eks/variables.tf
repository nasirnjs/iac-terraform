variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets IDs for EKS nodes"
  type        = list(string)
}

variable "enable_public_endpoint" {
  description = "Whether to enable public API endpoint"
  type        = bool
}

variable "node_instance_types" {
  description = "EC2 instance types for managed node group"
  type        = list(string)
}

variable "node_min" {
  description = "Minimum number of nodes"
  type        = number
}

variable "node_max" {
  description = "Maximum number of nodes"
  type        = number
}

variable "node_desired" {
  description = "Desired number of nodes"
  type        = number
}

variable "key_name" {
  description = "SSH key name for nodes"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all EKS resources"
  type        = map(string)
  default     = {}
}
variable "node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "general"   # or "main", "app", etc.
}