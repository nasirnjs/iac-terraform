aws_region   = "us-east-2"
project_name = "platform"
environment  = "production"

vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

cluster_name        = "platform-eks"
cluster_version     = "1.35"
public_access_cidrs = ["118.179.44.109/32"]

node_instance_types = ["t3a.medium"]
desired_size        = 1
min_size            = 1
max_size            = 4
node_group_ami_type = "AL2023_x86_64_STANDARD"

# Karpenter
karpenter_namespace         = "kube-system"
karpenter_chart_version     = "1.11.0"
karpenter_instance_families = ["t3a", "m5", "c6i"]
karpenter_ami_family        = "AL2023"
karpenter_ami_alias         = "al2023@latest"
karpenter_arch              = ["amd64"]

# Set to false if AWSServiceRoleForEC2Spot already exists in this account
create_spot_service_linked_role = true

# Max nodes Karpenter may disrupt concurrently (count or percentage)
karpenter_disruption_budget_nodes = "20%"