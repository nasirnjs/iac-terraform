variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones for the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "root_disk_size" {
  description = "Root EBS volume size in GiB"
  type        = number
}

# ----------------------------------------------------------------------------
# Auto Scaling Group
# ----------------------------------------------------------------------------
variable "asg_min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "asg_cpu_target" {
  description = "Target average CPU utilization for the ASG target-tracking scaling policy"
  type        = number
  default     = 60
}

# ----------------------------------------------------------------------------
# DNS / TLS
# ----------------------------------------------------------------------------
variable "domain_name" {
  description = "Primary FQDN served by the ALB (e.g., app.example.com)"
  type        = string
}

variable "route53_zone_name" {
  description = "Public Route 53 hosted zone name (e.g., example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional FQDNs to include in the ACM certificate"
  type        = list(string)
  default     = []
}

variable "create_acm_certificate" {
  description = "When true, Terraform creates and DNS-validates an ACM certificate. When false, supply acm_certificate_arn."
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "ARN of an existing ACM certificate (used only when create_acm_certificate = false)"
  type        = string
  default     = ""
}
