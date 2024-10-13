variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The region to deploy GKE"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "network" {
  description = "The name of the VPC network to use"
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnetwork to use"
  type        = string
}

variable "node_oauth_scopes" {
  description = "OAuth scopes for the node service account"
  type        = list(string)
}

variable "node_service_account" {
  description = "Service account for the node pools"
  type        = string
}

# Primary Node Pool Variables
variable "primary_machine_type" {
  description = "Machine type for the primary node pool"
  type        = string
}

variable "primary_disk_size_gb" {
  description = "Disk size in GB for the primary node pool"
  type        = number
}

variable "primary_disk_type" {
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

# Separate Node Pool Variables
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

# Image type for the primary node pool
variable "primary_image_type" {
  description = "The image type to use for the primary GKE nodes (e.g., COS_CONTAINERD, UBUNTU, etc.)"
  type        = string
  default     = "COS_CONTAINERD"
}

# Image type for the secondary node pool
variable "separate_image_type" {
  description = "The image type to use for the secondary GKE nodes (e.g., COS_CONTAINERD, UBUNTU, etc.)"
  type        = string
  default     = "COS_CONTAINERD"
}
