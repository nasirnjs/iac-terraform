# GCE variables
project_id             = "gce-web-438206"
region                 = "asia-southeast1"
instance_name          = "nasir-gce"
machine_type           = "n1-standard-1"
boot_image             = "ubuntu-minimal-2404-noble-amd64-v20241004"
instance_tags          = ["web", "app"]
ssh_keys               = "nasir"

# VPC variables
vpc_name               = "gce-vpc"
subnet_name            = "gce-subnet"
subnet_ip_cidr_range   = "10.10.0.0/16"

# Firewall variables
firewall_name          = "gce-firewall"
firewall_protocols     = ["icmp", "tcp"]
firewall_ports         = {
  "tcp"   = ["80", "22"]
  "icmp"  = []
}
firewall_source_tags    = ["web", "ssh"]
firewall_source_ranges  = ["0.0.0.0/0"]
zone                   = "asia-southeast1-a"
