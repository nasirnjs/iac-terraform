vpc_cidr_block          = "15.0.0.0/16"
vpc_name                = "yourmentors_vpc"
environment             = "dev"
public_subnet_az1       = "15.0.1.0/24"
public_subnet_az2       = "15.0.2.0/24"
private_subnet_az1      = "15.0.3.0/24"
private_subnet_az2      = "15.0.4.0/24"

alb_sg_name             = "alb_sg_allow_https"

instance_type           = "t2.micro"
key_name                = "nasir_tf"
db_password             = "kjsdfks3dsfs2llf"