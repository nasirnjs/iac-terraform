# Define the variables used in the configuration

variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region where the resources will be created."
  type        = string
}

variable "zone" {
  description = "The zone where the GCE instance will be created."
  type        = string
}

variable "vpc_name" {
  description = "The name of the existing VPC network to use."
  type        = string
}

variable "subnet_name" {
  description = "The name of the existing subnetwork to use."
  type        = string
}

variable "subnet_ip_cidr_range" {
  description = "The IP CIDR range for the subnet."
  type        = string
}

variable "instance_name" {
  description = "The name of the GCE instance to create."
  type        = string
}

variable "machine_type" {
  description = "The machine type for the GCE instance."
  type        = string
}

variable "boot_image" {
  description = "The boot image for the instance."
  type        = string
}

variable "ssh_keys" {
  description = "SSH keys to access the instance."
  type        = string
}

variable "instance_tags" {
  description = "Network tags to apply to the instance."
  type        = list(string)
}

# VPC Firewall variables
variable "firewall_name" {
  description = "The name of the firewall rule to create."
  type        = string
}

variable "firewall_protocols" {
  description = "Protocols to allow in the firewall."
  type        = list(string)
}

variable "firewall_ports" {
  description = "Ports to allow in the firewall for each protocol."
  type        = map(list(string))
}

variable "firewall_source_tags" {
  description = "Source tags for the firewall rules."
  type        = list(string)
}

variable "firewall_source_ranges" {
  description = "Source IP ranges for the firewall rules."
  type        = list(string)
}
