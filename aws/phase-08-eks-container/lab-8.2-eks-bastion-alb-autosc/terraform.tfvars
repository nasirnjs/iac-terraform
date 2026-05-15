aws_region   = "us-east-2"
project_name = "platform"
environment  = "production"

vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

cluster_name    = "platform-eks"
cluster_version = "1.35"

node_instance_types = ["t3a.medium"]
desired_size        = 1
min_size            = 1
max_size            = 4
node_group_ami_type = "AL2023_x86_64_STANDARD"

bastion_instance_type = "t2.micro"
# Ubuntu 24.04 LTS (Noble) amd64, gp3, in us-east-2 — Canonical build 20260507
bastion_ami_id       = "ami-02313bf7c0d264d2c"
bastion_key_name     = "nasir-us-east-2-key"
bastion_allowed_cidr = "118.179.44.109/32"