variable "environment" {
  description = "The environment name"
  type        = string
}

variable "instance_class" {
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

variable "rds_sg_id" {
  description = "The security group ID for RDS"
  type        = string
}

variable "private_subnet_one_id" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_two_id" {
  description = "CIDR block for the second private subnet"
  type        = string
}
