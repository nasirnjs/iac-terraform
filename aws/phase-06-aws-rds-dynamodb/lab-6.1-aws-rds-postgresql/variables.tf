
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


variable "ec2_name" {
  description = "Name of the VPC"
  type        = string
}
variable "ami" {
  description = "Name of the OS AMI"
  type        = string
}
variable "instance_type" {
  description = "Name of the VPC"
  type        = string
}
variable "key_name" {
  description = "Name of the VPC"
  type        = string
}
variable "root_disk_size" {
  description = "Name of the VPC"
  type        = string
}
variable "data_disk_size" {
  description = "Name of the VPC"
  type        = string
}

# RDS PostgreSQL
variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "db_family" {
  description = "RDS parameter group family (e.g., postgres16)"
  type        = string
}

variable "db_major_engine_version" {
  description = "PostgreSQL major engine version (e.g., 16)"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password (write-only, not stored in state)"
  type        = string
  ephemeral   = true
  sensitive   = true
}

variable "db_password_version" {
  description = "Password version counter — increment to rotate the password"
  type        = number
  default     = 1
}

variable "db_max_connections" {
  description = "PostgreSQL max_connections parameter"
  type        = number
  default     = 200
}

variable "db_allowed_cidr" {
  description = "CIDR allowed to reach RDS on 5432 (default: VPC CIDR)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_template" {
  description = "RDS template preset: production, dev-test, or sandbox. Drives multi_az, performance_insights, monitoring, and final snapshot defaults."
  type        = string
  default     = "dev-test"

  validation {
    condition     = contains(["production", "dev-test", "sandbox"], var.db_template)
    error_message = "db_template must be one of: production, dev-test, sandbox."
  }
}

variable "db_deletion_protection" {
  description = "Enable deletion protection for the RDS instance"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days (0-35)"
  type        = number
  default     = 1

  validation {
    condition     = var.db_backup_retention_period >= 0 && var.db_backup_retention_period <= 35
    error_message = "db_backup_retention_period must be between 0 and 35."
  }
}

variable "db_create_read_replica" {
  description = "Create read replica(s) of the primary RDS instance"
  type        = bool
  default     = false
}

variable "db_read_replica_count" {
  description = "Number of read replicas to create when db_create_read_replica is true"
  type        = number
  default     = 1

  validation {
    condition     = var.db_read_replica_count >= 0 && var.db_read_replica_count <= 5
    error_message = "db_read_replica_count must be between 0 and 5."
  }
}

variable "db_read_replica_instance_class" {
  description = "Instance class for read replicas. If null, falls back to db_instance_class."
  type        = string
  default     = null
}