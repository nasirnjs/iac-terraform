# VPC Variables
# Environment name (e.g., dev, prod)
variable "environment" {
  description = "The name of the environment (e.g., dev, prod)"
  type        = string
}

# CIDR block for the VPC
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

# CIDR block for the public subnet
variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

# CIDR blocks for the private subnets (1st private subnet)
variable "private_subnet_cidr_blocks_one" {
  description = "CIDR block(s) for the first private subnet"
  type        = list(string)
}

# CIDR blocks for the private subnets (2nd private subnet)
variable "private_subnet_cidr_blocks_two" {
  description = "CIDR block(s) for the second private subnet"
  type        = list(string)
}

# Region for the resources (optional)
variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}
# EC2 Variables

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

# RDS
variable "db_instance_class" {
  description = "The instance type for the RDS instance"
  type        = string
}

variable "db_user_name" {
  description = "The username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the RDS database"
  type        = string
}