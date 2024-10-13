provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source      = "../../modules/vpc"
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  subnet_cidr = var.subnet_cidr
  region      = var.region
}

module "gke" {
  source                  = "../../modules/gke"
  project_id              = var.project_id
  region                  = var.region
  cluster_name            = var.cluster_name
  network                 = module.vpc.network_name
  subnetwork              = module.vpc.subnetwork_name
  node_oauth_scopes       = var.node_oauth_scopes
  node_service_account    = var.node_service_account

  # For primary node pool
  primary_machine_type    = var.node_machine_type
  primary_disk_size_gb    = var.disk_size_gb
  primary_disk_type       = var.disk_type
  min_primary_node_count  = var.min_primary_node_count
  max_primary_node_count  = var.max_primary_node_count
  primary_image_type  = var.primary_image_type

  # For separate node pool
  separate_machine_type   = var.separate_machine_type
  separate_disk_size_gb   = var.separate_disk_size_gb
  separate_disk_type      = var.separate_disk_type
  min_separate_node_count = var.min_separate_node_count
  max_separate_node_count = var.max_separate_node_count
  separate_image_type = var.separate_image_type

}
