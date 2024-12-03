variable "vpc_id" {
  type        = string
  description = "The ID of the VPC for Redis"
}
variable "private_subnet_az1" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}
variable "private_subnet_az2" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}
variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)."
  type        = string
}
variable "redis_sg_ids" {
  description = "The environment name (e.g., dev, staging, prod)."
  type        = string
}
