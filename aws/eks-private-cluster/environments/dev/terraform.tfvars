
aws_region              = "us-west-2"
vpc_cidr_block          = "10.0.0.0/16"
subnet_public-1_cidr    = "10.0.1.0/24"
subnet_public-2_cidr    = "10.0.2.0/24"
subnet_private-1_cidr   = "10.0.3.0/24"
subnet_private-2_cidr   = "10.0.4.0/24"
cluster_name            = "aws-eks-cluster"
created_by              = "aws"  
ami_id                  = "ami-04dd23e62ed049936"
bastion_host_ec2_size   = "t2.medium"
node_group_min_size     = 2
node_group_max_size     = 10
node_group_desired_size = 2
instance_types          = ["t2.medium"] 
capacity_type           = "ON_DEMAND"
