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
# variable "redis_sg_ids" {
#   description = "List of security group IDs for the Redis cluster"
#   type        = list
# }

# # ec2 instance

# variable "instance_type" {
#   description = "Environment name (e.g., dev, prod)"
#   type        = string
# }
# variable "key_name" {
#     description = "Key to access the EC2 instance"
#     type = string
# }
# variable "db_password" {
#     description = "Key to access the EC2 instance"
#     type = string
# }
# # s3
# variable "s3_bucket_name" {
#     description = "Key to access the EC2 instance"
#     type = string
# }