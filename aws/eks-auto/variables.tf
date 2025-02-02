variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-automode"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}


variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}

variable "cluster_version" {
  description = "The version of EKS to use"
  type        = string
  default     = "1.31"
}
