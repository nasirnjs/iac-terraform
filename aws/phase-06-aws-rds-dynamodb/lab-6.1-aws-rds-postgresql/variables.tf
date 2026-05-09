
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
variable "root_disk_size" {
  description = "Name of the VPC"
  type        = string
}
variable "data_disk_size" {
  description = "Name of the VPC"
  type        = string
}

# RDS PostgreSQL
variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password (write-only, not stored in state)"
  type        = string
  ephemeral   = true
  sensitive   = true
}

variable "db_password_version" {
  description = "Password version counter — increment to rotate the password"
  type        = number
  default     = 1
}

variable "db_max_connections" {
  description = "PostgreSQL max_connections parameter"
  type        = number
  default     = 200
}

variable "db_allowed_cidr" {
  description = "CIDR allowed to reach RDS on 5432 (default: VPC CIDR)"
  type        = string
  default     = "10.0.0.0/16"
}