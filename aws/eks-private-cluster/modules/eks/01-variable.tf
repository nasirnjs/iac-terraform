variable "aws_region" {
  description = "your aws region"
  type        = string
  #default     = "ap-south-1"
}

variable "cluster_name" {
  description = "name of the cluster, will be the name of the VPC,should be unique"
  type        = string
  #default     = "Instance"
}

variable "created_by" {
  description = "created by xyz metadata"
  type        = string
  #default     = "xyz"
}

variable "vpc_cidr_block" {
  description = "cidr range of the VPC"
  type        = string
  #default     = "10.0.0.0/16"
}

variable "subnet_public-1_cidr" {
  description = "cidr range of the public subnet 1"
  type        = string
  default     = "10.0.32.0/20"
}

variable "subnet_public-2_cidr" {
  description = "cidr range of the public subnet 2"
  type        = string
  default     = "10.0.48.0/20"
}

variable "subnet_private-1_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
  default     = "10.0.0.0/20"
}

variable "subnet_private-2_cidr" {
  description = "cidr range of the private subnet 2"
  type        = string
  default     = "10.0.16.0/20"
}

variable "subnet_id_private_1" {
  description = "subnet_id_pprivate_1 to be used in cluster"
  type = string
}
variable "subnet_id_private_2" {
  description = "subnet_id_pprivate_1 to be used in cluster"
  type = string
}

variable "bastion_host_role_arn" {
  description = "module.bastion_host.bh_role.arn"
  type = string
}
variable "node_group_desired_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
}
variable "node_group_min_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
}
variable "node_group_max_size" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
}
variable "capacity_type" {
  description = "Capacity type for the EKS node group (e.g., ON_DEMAND, SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
}

