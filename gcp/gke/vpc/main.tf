#  Terraform version specification 
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

# Create a VPC Network
resource "google_compute_network" "gke_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Create a Subnet
resource "google_compute_subnetwork" "gke_subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.gke_vpc.id
  ip_cidr_range = var.subnet_ip_cidr_range
}
# Create a Firewall
resource "google_compute_firewall" "gke_firewall" {
  name    = var.firewall_name

  dynamic "allow" {
    for_each = var.firewall_protocols
    content {
      protocol = allow.value
      ports    = lookup(var.firewall_ports, allow.value, [])
    }
  }
  source_tags    = var.firewall_source_tags
  direction      = "INGRESS"
  source_ranges  = var.firewall_source_ranges
  network        = google_compute_network.gke_vpc.id
}

/*
# Firewall 
resource "google_compute_firewall" "gke_firewall" {
  name    = "gke-firewall"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  source_tags = ["web ssh"]
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  network = google_compute_network.gke_vpc.id
}
*/

