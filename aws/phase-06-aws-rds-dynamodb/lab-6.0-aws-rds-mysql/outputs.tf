output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}
output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = module.vpc.public_subnets_cidr_blocks
}
output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}
output "availability_zones" {
  description = "Availability Zones used by the VPC"
  value       = module.vpc.azs
}

# EC2 Instance Outputs

output "ec2_instance_name" {
  description = "Name of the EC2 instance"
  value       = module.ec2_instance.id # or instance_id
}

output "ec2_instance_type" {
  description = "EC2 instance type"
  value       = module.ec2_instance.id # or instance_id (if type isn't exposed)
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}

# RDS MySQL Outputs
output "rds_endpoint" {
  description = "RDS endpoint (host:port)"
  value       = module.rds_mysql.db_instance_endpoint
}

output "rds_address" {
  description = "RDS hostname"
  value       = module.rds_mysql.db_instance_address
}

output "rds_port" {
  description = "RDS port"
  value       = module.rds_mysql.db_instance_port
}

output "rds_db_name" {
  description = "Initial database name"
  value       = module.rds_mysql.db_instance_name
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = module.rds_mysql.db_instance_identifier
}

