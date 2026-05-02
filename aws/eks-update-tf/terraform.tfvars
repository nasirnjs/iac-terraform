aws_region        = "us-east-2"
project_name      = "platform"
environment       = "production"

vpc_cidr          = "10.0.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

private_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets    = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

cluster_name      = "platform-eks"
cluster_version   = "1.35"

node_instance_types = ["t3a.medium"]
desired_size        = 1
min_size            = 1
max_size            = 4