# variables.tf
variable "aws_region" {
  type    = string
}

variable "vpc_cidr_block" {
  type    = string
}

variable "subnet_public-1_cidr" {
  type    = string
}

variable "subnet_public-2_cidr" {
  type    = string
}

variable "subnet_private-1_cidr" {
  type    = string
}

variable "subnet_private-2_cidr" {
  type    = string
}

variable "cluster_name" {
  type    = string
}

variable "created_by" {
  type    = string
}

variable "bastion_host_ec2_size" {
  description = "Your bastion host EC2 instance size"
  type        = string
}

variable "ami_id" {
  description = "AMI ID of your EC2 instance"
  type        = string
}


variable "node_group_min_size" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
}
variable "node_group_desired_size" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
}

variable "instance_types" {
  description = "Instance types for the EKS node group (e.g., t3.large)"
  type        = list(string)
}
variable "capacity_type" {
  description = "Capacity type for the EKS node group (e.g., ON_DEMAND, SPOT)"
  type        = string
  default     = "ON_DEMAND"
}
