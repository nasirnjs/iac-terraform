variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "The CIDR block for the private subnet"
  type        = string
}

variable "environment" {
  description = "Environment for resources, e.g., dev, test, prod"
  type        = string
}

variable "created_by" {
  description = "The creator or owner of the resources"
  type        = string
}
variable "db_password" {
  description = "The creator or owner of the resources"
  type        = string
}
