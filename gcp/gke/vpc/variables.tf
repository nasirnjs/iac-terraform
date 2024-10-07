variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region for the VPC and subnet"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "gke-vpc"
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string

}

variable "subnet_ip_cidr_range" {
  description = "The IP range for the subnet"
  type        = string

}
# Firewall
variable "firewall_name" {
  description = "Name of the firewall rule"
  type        = string
}
variable "firewall_protocols" {
  description = "List of protocols allowed"
  type        = list(string)
}
variable "firewall_ports" {
  description = "Ports to allow for specific protocols"
  type        = map(list(string))
}
variable "firewall_source_tags" {
  description = "Source tags for firewall rules"
  type        = list(string)
}
variable "firewall_source_ranges" {
  description = "Source IP CIDR ranges for the firewall rule"
  type        = list(string)
}