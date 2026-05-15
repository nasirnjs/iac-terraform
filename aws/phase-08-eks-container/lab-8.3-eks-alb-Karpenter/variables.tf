variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
}

variable "project_name" {
  description = "Project name (used as a prefix/tag for resources)"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to access the EKS public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  description = "Worker node instance types"
  type        = list(string)
}

variable "node_group_ami_type" {
  description = "AMI type for the EKS managed node group (e.g. AL2023_x86_64_STANDARD)"
  type        = string
}
variable "desired_size" {
  description = "Desired node count"
  type        = number
}

variable "min_size" {
  description = "Minimum node count"
  type        = number
}

variable "max_size" {
  description = "Maximum node count"
  type        = number
}

# ---------------------------------------------------------------------
# Karpenter
# ---------------------------------------------------------------------
variable "karpenter_namespace" {
  description = "Kubernetes namespace for the Karpenter controller"
  type        = string
}

variable "karpenter_chart_version" {
  description = "Karpenter Helm chart version"
  type        = string
}

variable "karpenter_instance_families" {
  description = "EC2 instance families Karpenter is allowed to provision"
  type        = list(string)
}

variable "karpenter_ami_family" {
  description = "AMI family for Karpenter-provisioned nodes (e.g. AL2023, Bottlerocket)"
  type        = string
}

variable "karpenter_ami_alias" {
  description = "AMI alias used by EC2NodeClass amiSelectorTerms (e.g. al2023@latest, bottlerocket@latest)"
  type        = string
}

variable "karpenter_arch" {
  description = "CPU architectures Karpenter is allowed to provision"
  type        = list(string)
}

variable "create_spot_service_linked_role" {
  description = "Whether to create the AWSServiceRoleForEC2Spot service-linked role. Set to false if it already exists in the account."
  type        = bool
}

variable "karpenter_disruption_budget_nodes" {
  description = "NodePool disruption budget — max nodes Karpenter may disrupt concurrently (count or percentage, e.g. \"10%\" or \"3\")"
  type        = string
}