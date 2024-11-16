variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr_blocks_one" {
  description = "CIDR blocks for the first private subnet"
  type        = list(string)
}

variable "private_subnet_cidr_blocks_two" {
  description = "CIDR blocks for the second private subnet"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
