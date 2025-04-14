aws_region = "us-east-2"
cluster_name = "buddy-cluster"
created_by   = "nasir-buddy"
vpc_cidr_block = "12.0.0.0/16"
subnet_private_1_cidr = "12.0.1.0/24"
subnet_private_2_cidr = "12.0.2.0/24"
subnet_public_1_cidr = "12.0.3.0/24"
subnet_public_2_cidr = "12.0.4.0/24"
capacity_type       = "ON_DEMAND"
node_group_min_size     = 1
node_group_max_size     = 5
node_group_desired_size = 1
max_unavailable         = 1
instance_types          = ["c6i.large"]
# bastion-host
ami_id                  = "ami-0ea3c35c5c3284d82"
bastion_host_ec2_size   = "t2.micro"