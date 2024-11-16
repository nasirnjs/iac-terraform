variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID"
}

variable "private_subnet_one_id" {
  type        = string
  description = "Private subnet one ID"
}

variable "private_subnet_two_id" {
  type        = string
  description = "Private subnet two ID"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}
# 
