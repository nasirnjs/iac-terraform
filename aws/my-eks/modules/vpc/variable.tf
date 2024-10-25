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
variable "subnet_private-1_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}
variable "subnet_private-2_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}
variable "subnet_public-1_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}
variable "subnet_public-2_cidr" {
  description = "cidr range of the private subnet 1"
  type        = string
}