variable "aws_region" {
  description = "your aws region"
  type        = string
}
variable "cluster_name" {
  description = "name of the cluster, will be the name of the VPC,should be unique"
  type        = string
}
variable "created_by" {
  description = "created by xyz metadata"
  type        = string
}
# variable "k8s_version" {
#   description = "k8s_version"
#   type        = string
# }
variable "vpc_cidr_block" {
  description = "cidr range of the VPC"
  type        = string
}
# variable "subnet_private_1_cidr" {
#   description = "k8s_version"
#   type        = string
# }
# variable "subnet_private_2_cidr" {
#   description = "k8s_version"
#   type        = string
# }
# this from vpc modules outputs.tf

variable "subnet_id_private_1" {
  description = "subnet_id_pprivate_1 to be used in cluster"
  type = string
}
variable "subnet_id_private_2" {
  description = "subnet_id_pprivate_1 to be used in cluster"
  type = string
}

variable "capacity_type" {
  description = "capacity type"
  type        = string
}
variable "instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
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
# bastion host
variable "bastion_host_role_arn" {
  description = "module.bastion_host.bh_role.arn"
  type = string
}