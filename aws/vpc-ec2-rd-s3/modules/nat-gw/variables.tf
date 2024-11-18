variable "environment" {
    description = "value"
    type = string  
}
variable "ym_vpc_id" {
    description = "value"
    type = string  
}
variable "public_subnet_az1" {
    description = "public_subnet_az1.id"
    type = string  
}
variable "private_subnet_az1" {
    description = "private_subnet_az1.id"
    type = string  
}
variable "private_subnet_az2" {
  description = "private_subnet_az2.id"
  type        = string
}

variable "internet_gateway" {
  description = "Internet Gateway ID from VPC module"
  type        = string
}
