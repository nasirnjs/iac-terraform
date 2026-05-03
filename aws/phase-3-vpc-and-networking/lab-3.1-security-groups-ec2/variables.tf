
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones for the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}


variable "ec2_name" {
  description = "Name of the VPC"
  type        = string
}
variable "ami" {
  description = "Name of the OS AMI"
  type        = string
}
variable "instance_type" {
  description = "Name of the VPC"
  type        = string
}
variable "key_name" {
  description = "Name of the VPC"
  type        = string
}