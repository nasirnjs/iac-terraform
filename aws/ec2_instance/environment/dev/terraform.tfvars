# VPC
vpc_cidr_block                 = "10.0.0.0/16"
public_subnet_cidr_block       = "10.0.1.0/24"
private_subnet_cidr_blocks_one = ["10.0.2.0/24"]
private_subnet_cidr_blocks_two = ["10.0.3.0/24"]
environment                    = "dev"
# EC2
instance_type                   = "t2.micro"

# RDS
db_password = "hdy342d3533dD"
db_user_name = "admin"
db_name = "mydb"
db_instance_class = "db.c6gd.medium"