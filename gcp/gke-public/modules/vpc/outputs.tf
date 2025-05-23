output "network_name" {
  value = google_compute_network.vpc_network.name
}

output "subnetwork_name" {
  value = google_compute_subnetwork.vpc_subnet.name
}

output "vpc_name" {
  value = google_compute_network.vpc_network.name
}
