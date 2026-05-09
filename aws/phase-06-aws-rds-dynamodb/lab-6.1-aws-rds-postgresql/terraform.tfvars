
vpc_name       = "prod-vpc"
vpc_cidr_block = "10.0.0.0/16"
environment    = "prod"

availability_zones = [
  "us-east-2a",
  "us-east-2b",
  "us-east-2c"
]

public_subnets = [
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24"
]

private_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

ec2_name       = "single-instance"
instance_type  = "t3a.medium"
key_name       = "nasir-us-east-2-key"
ami            = "ami-0fe18bc3cfa53a248"
root_disk_size = "20"
data_disk_size = "20"

# RDS PostgreSQL
db_identifier           = "prod-postgresql"
db_engine_version       = "18.2"
db_family               = "postgres18"
db_major_engine_version = "18"
db_instance_class       = "db.t4g.micro"
db_allocated_storage    = 20
db_name                 = "appdb"
db_username             = "postgres"
db_password             = "ChangeMeStrongPwd123!"
db_password_version     = 1
db_max_connections      = 200
db_allowed_cidr         = "10.0.0.0/16"

# Template: production | dev-test | sandbox
db_template                = "dev-test"
db_deletion_protection     = false
db_backup_retention_period = 7

# Read Replica
db_create_read_replica         = true
db_read_replica_count          = 1
db_read_replica_instance_class = null