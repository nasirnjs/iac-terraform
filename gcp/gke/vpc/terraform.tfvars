project_id          = "aes-test-gke"
region              = "asia-southeast1"
vpc_name            = "gke-vpc"
subnet_name         = "gke-subnet"
subnet_ip_cidr_range= "10.0.0.0/16"

# Firewall variables
firewall_name       = "gke-firewall"
firewall_protocols  = ["icmp","tcp"]
firewall_ports      = {
  "tcp" = ["80", "22"]
  "icmp" = []  # ICMP doesn't have ports, so leave it empty
}
firewall_source_tags  = ["web", "ssh"]
firewall_source_ranges = ["0.0.0.0/0"]