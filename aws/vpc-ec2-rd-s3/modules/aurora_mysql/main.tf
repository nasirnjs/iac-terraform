resource "aws_db_subnet_group" "ym_rds_subnet_group" {
  name       = "ym-rds-subnet-group"
  subnet_ids = [
    var.private_subnet_az1,
    var.private_subnet_az2
  ]

  tags = {
    Name        = "ym-rds-subnet-group"
    Environment = var.environment
  }
}

# Create the RDS Cluster
resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier = "example"
  engine             = "aurora-mysql"
  engine_mode        = "provisioned"
  engine_version     = "8.0.mysql_aurora.3.06.0"
  database_name      = "test"
  master_username    = "test"
  master_password    = "Pass4fsfsfYour34FDS"
  deletion_protection = false
  skip_final_snapshot = true

  # Associate the DB Subnet Group with the RDS Cluster
  db_subnet_group_name = aws_db_subnet_group.ym_rds_subnet_group.name

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

# Declare the AWS availability zones data resource
data "aws_availability_zones" "available" {
  state = "available"
}

# Create RDS Cluster Instances in different Availability Zones
resource "aws_rds_cluster_instance" "serverless_instance_1" {
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  availability_zone    = data.aws_availability_zones.available.names[0]
  db_subnet_group_name = aws_db_subnet_group.ym_rds_subnet_group.name
}

resource "aws_rds_cluster_instance" "serverless_instance_2" {
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  availability_zone    = data.aws_availability_zones.available.names[1]
  db_subnet_group_name = aws_db_subnet_group.ym_rds_subnet_group.name
}
