
variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "instance_type" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "public_subnet_az1" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
}
