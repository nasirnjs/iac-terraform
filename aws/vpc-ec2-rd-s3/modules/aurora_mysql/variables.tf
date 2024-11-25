variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "db_password" {
  description = "Password for the database"
  sensitive   = true
}

variable "private_subnet_az1" {
  description = "Private Subnet AZ1 ID"
  type        = string
}

variable "private_subnet_az2" {
  description = "Private Subnet AZ2 ID"
  type        = string
}
variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with Aurora MySQL cluster"
  type        = list(string)
}