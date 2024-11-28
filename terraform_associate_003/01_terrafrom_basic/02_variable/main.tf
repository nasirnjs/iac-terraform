provider "aws" {
  region = var.region
}
output "available_zones" {
  description = "List of availability zones"
  value       = var.availability_zones
}
