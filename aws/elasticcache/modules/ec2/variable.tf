variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "sg_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "instance_type" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "key_name" {
    description = "Key to access the EC2 instance"
    type = string
}