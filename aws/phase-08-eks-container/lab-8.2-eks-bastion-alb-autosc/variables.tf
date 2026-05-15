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

variable "node_instance_types" {
  description = "Worker node instance types"
  type        = list(string)
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

variable "node_group_ami_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion host (e.g. an Ubuntu 24.04 LTS AMI in the target region)"
  type        = string
}

variable "bastion_key_name" {
  description = "Name of an existing EC2 key pair for SSH access to the bastion"
  type        = string
}

variable "bastion_allowed_cidr" {
  description = "CIDR allowed to SSH to the bastion (typically your office/home IP /32)"
  type        = string
}