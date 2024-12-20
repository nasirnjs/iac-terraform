variable "bucket_name" {
  type        = string
  description = "Test bucket"
  default     = "ym-devops-b1"
}
variable "env_name" {
  type        = string
  description = "Environemnt"
  default     = "dev"
}

variable "log_bucket_name" {
  type        = string
  description = "Test bucket"
  default     = "ym-devops-b1-logs"
}