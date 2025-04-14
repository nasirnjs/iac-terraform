variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "cluster_name" {
  description = "name of the cluster, will be the name of the VPC,should be unique"
  type        = string
}
variable "created_by" {
  description = "created by Instance metadata"
  type        = string
}
# variable "k8s_version" {
#   description = "k8s version"
#   type        = string
# }
variable "vpc_cidr_block" {
  type    = string
}
variable "subnet_private_1_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}
variable "subnet_private_2_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}
variable "subnet_public_1_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}
variable "subnet_public_2_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}
variable "capacity_type" {
  description = "capacity type"
  type        = string
}
variable "instance_types" {
  description = "Instance types for the EKS node group (e.g., t3.large)"
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
## bastion host
variable "ami_id" {
  description = "AMI ID of your EC2 instance"
  type        = string
}
variable "bastion_host_ec2_size" {
  description = "Your bastion host EC2 instance size"
  type        = string
}
##
variable "max_unavailable" {
  description = "Maximum number of nodes that can be unavailable during update"
  type        = number
  #default     = 1
}
