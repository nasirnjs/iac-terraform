output "network_name" {
  value = module.vpc.network_name
}

output "subnetwork_name" {
  value = module.vpc.subnetwork_name
}

output "vpc_name" {
  value = module.vpc.vpc_name
}

output "cluster_name" {
  value = module.gke.cluster_name
}

output "gke_endpoint" {
  value = module.gke.gke_endpoint
  sensitive = true
}
