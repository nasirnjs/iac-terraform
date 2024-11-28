variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
