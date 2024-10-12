resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region

  network    = var.network
  subnetwork = var.subnetwork

  # Enable Stackdriver Logging and Monitoring
  # monitoring_service = "monitoring.googleapis.com"
  # logging_service    = "logging.googleapis.com"

  # Disable the default node pool creation
  remove_default_node_pool = true

  # Set initial node count
  initial_node_count = 1
}

# Primary Node Pool
resource "google_container_node_pool" "primary_pool" {
  name     = "${var.cluster_name}-primary-pool"
  location = var.region
  cluster  = google_container_cluster.gke_cluster.name

  # Enable autoscaling
  autoscaling {
    min_node_count = var.min_primary_node_count
    max_node_count = var.max_primary_node_count
  }

  node_config {
    machine_type    = var.primary_machine_type
    disk_size_gb    = var.primary_disk_size_gb
    disk_type       = var.primary_disk_type
    oauth_scopes    = var.node_oauth_scopes
    service_account  = var.node_service_account
  }
}

# Separate Node Pool
resource "google_container_node_pool" "separate_pool" {
  name     = "${var.cluster_name}-separate-pool"
  location = var.region
  cluster  = google_container_cluster.gke_cluster.name

  # Enable autoscaling
  autoscaling {
    min_node_count = var.min_separate_node_count
    max_node_count = var.max_separate_node_count
  }

  node_config {
    machine_type    = var.separate_machine_type
    disk_size_gb    = var.separate_disk_size_gb
    disk_type       = var.separate_disk_type
    oauth_scopes    = var.node_oauth_scopes
    service_account  = var.node_service_account
  }
}
