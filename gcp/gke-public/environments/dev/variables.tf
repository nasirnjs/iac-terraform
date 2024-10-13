variable "project_id" {
  description = "The ID of the project"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "node_oauth_scopes" {
  description = "OAuth scopes for the node service account"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "node_service_account" {
  description = "The service account to be used by the nodes"
  type        = string
}

variable "node_machine_type" {
  description = "Machine type for the primary node pool"
  type        = string
}

variable "disk_size_gb" {
  description = "Disk size in GB for the primary node pool"
  type        = number
}

variable "disk_type" {
  description = "Disk type for the primary node pool"
  type        = string
}

variable "min_primary_node_count" {
  description = "Minimum nodes in the primary node pool"
  type        = number
}

variable "max_primary_node_count" {
  description = "Maximum nodes in the primary node pool"
  type        = number
}

variable "separate_machine_type" {
  description = "Machine type for the separate node pool"
  type        = string
}

variable "separate_disk_size_gb" {
  description = "Disk size in GB for the separate node pool"
  type        = number
}

variable "separate_disk_type" {
  description = "Disk type for the separate node pool"
  type        = string
}

variable "min_separate_node_count" {
  description = "Minimum nodes in the separate node pool"
  type        = number
}

variable "max_separate_node_count" {
  description = "Maximum nodes in the separate node pool"
  type        = number
}

variable "environment" {
  description = "The environment for the GKE cluster (e.g., dev, prod)"
  type        = string
}
variable "primary_image_type" {
  description = "Primary node pool image type"
  type        = string
}

variable "separate_image_type" {
  description = "Separate node pool image type"
  type        = string
}
