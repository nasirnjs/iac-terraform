variable "vpc_cidr_block" {
    description = "value"
    type = string
}
variable "vpc_name" {
    description = "value"
    type = string 
}
variable "environment" {
    description = "value"
    type = string 
}
# 
variable "public_subnet_az1" {
    type = string
    description = "value" 
}
variable "public_subnet_az2" {
    type = string
    description = "value"
}
#
variable "private_subnet_az1" {
    type = string
    description = "value"  
}
variable "private_subnet_az2" {
    type = string
    description = "value"
}
variable "alb_sg_name" {
    type = string
    description = "value"
}
# ec2 instance

variable "instance_type" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
variable "key_name" {
    description = "Key to access the EC2 instance"
    type = string
}