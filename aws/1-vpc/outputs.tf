

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}


output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}



output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.natgw_ids
}

output "nat_public_ips" {
  description = "Public Elastic IPs of NAT Gateway(s)"
  value       = module.vpc.nat_public_ips
}



output "public_route_table_ids" {
  description = "List of public route table IDs"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = module.vpc.private_route_table_ids
}



output "availability_zones" {
  description = "Availability Zones used by the VPC"
  value       = module.vpc.azs
}