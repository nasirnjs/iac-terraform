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
variable "vpc_cidr_block" {
  description = "cidr range of the VPC"
  type        = string
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