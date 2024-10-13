# GCP Project and Region Settings
project_id           = "nasir-gke-pub-dev"
region               = "asia-east1"

# VPC Settings
vpc_name             = "dev-vpc"
environment          = "dev"
subnet_name          = "dev-subnet"
subnet_cidr          = "10.0.0.0/24"

# GKE Cluster Settings
cluster_name         = "nasir-dev-cluster"
node_machine_type    = "c2d-highcpu-4"
disk_size_gb         = 100
disk_type            = "pd-standard"
node_oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
node_service_account = "nasir-gke-pub@nasir-gke-pub-dev.iam.gserviceaccount.com"

# Primary Node Pool Autoscaling Settings
min_primary_node_count = 1  # Minimum nodes for primary pool
max_primary_node_count = 3  # Maximum nodes for primary pool
primary_image_type  = "COS_CONTAINERD"


# Separate Node Pool Autoscaling Settings
min_separate_node_count = 1  # Minimum nodes for separate pool
max_separate_node_count = 3  # Maximum nodes for separate pool

# Separate Node Pool Settings
separate_machine_type   = "e2-standard-4"
separate_disk_size_gb   = 100
separate_disk_type      = "pd-standard"
separate_image_type = "COS_CONTAINERD"

