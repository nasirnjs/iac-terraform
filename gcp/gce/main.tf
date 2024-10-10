# Terraform version specification
terraform {
  required_version = ">= 1.9"       # Specify the minimum required version of Terraform

  required_providers {
    google = {
      source  = "hashicorp/google"  # The source for the Google provider
      version = "~> 6.5"            # Specify the version constraint for the Google provider
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false  # Disable auto subnet creation
}

# Create a Subnetwork
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_cidr_range
  region       = var.region
  network      = google_compute_network.vpc_network.id
}

# Create a Firewall
resource "google_compute_firewall" "gke_firewall" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.id

  dynamic "allow" {
    for_each = var.firewall_protocols
    content {
      protocol = allow.value
      ports    = lookup(var.firewall_ports, allow.value, [])
    }
  }

  source_tags    = var.firewall_source_tags
  source_ranges  = var.firewall_source_ranges
}


# Create a GCE Instance
resource "google_compute_instance" "gce_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_image
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id    # Reference to the VPC network
    subnetwork = google_compute_subnetwork.vpc_subnet.id    # Reference to the Subnetwork

    access_config {
      # Assign an ephemeral public IP address for external access
    }
  }

  metadata = {
    ssh-keys = var.ssh_keys
  }

  tags = var.instance_tags
}
