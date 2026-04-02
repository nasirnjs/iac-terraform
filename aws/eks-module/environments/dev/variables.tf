# ----------------------------
# VPC Variables
# ----------------------------
variable "region" {
  description = "AWS Region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (2 subnets)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (2 subnets)"
  type        = list(string)
}
# ----------------------------
# Common Tags
# ----------------------------
variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
# ----------------------------
# EKS Variables
# ----------------------------
variable "name" {
  description = "Name of the EKS cluster for dev"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for dev EKS cluster"
  type        = string
}

variable "enable_public_endpoint" {
  description = "Enable public endpoint for EKS API"
  type        = bool
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS managed node group"
  type        = list(string)
}

variable "node_min" {
  description = "Minimum number of nodes in managed node group"
  type        = number
}

variable "node_max" {
  description = "Maximum number of nodes in managed node group"
  type        = number
}

variable "node_desired" {
  description = "Desired number of nodes in managed node group"
  type        = number
}

variable "key_name" {
  description = "SSH key name to access EKS nodes"
  type        = string
}
variable "node_group_name" {
  description = "Name of the EKS managed node group"
  type        = string
}
#bastion-host
variable "ami_id" {
  description = "AMI ID for bastion host"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
}