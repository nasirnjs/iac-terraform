variable "project_info" {
  type = list(string)
}
variable "vpc_cidr_block" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "domain_name_servers" {
  type    = list(string)
  default = ["AmazonProvidedDNS"]
}

variable "public_subnets" {}

variable "public_route_table_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "private_subnets" {}

variable "private_route_table_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}


variable "enable_secondary_cidr" {
  type    = bool
  default = false
}

variable "secondary_cidr_block" {
  type    = string
  default = "100.64.0.0/16"
}

variable "subnet_count" {
  type    = number
  default = 3
}
