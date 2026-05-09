module "rds_postgresql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = var.db_identifier

  engine               = "postgres"
  engine_version       = var.db_engine_version
  family               = "postgres16"
  major_engine_version = "16"
  instance_class       = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name             = var.db_name
  username            = var.db_username
  password_wo         = var.db_password
  password_wo_version = var.db_password_version
  port                = 5432

  manage_master_user_password = false

  multi_az            = false
  publicly_accessible = false

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  vpc_security_group_ids = [module.rds_postgresql_sg.security_group_id]

  backup_retention_period    = 1
  skip_final_snapshot        = true
  deletion_protection        = false
  auto_minor_version_upgrade = true
  apply_immediately          = true

  performance_insights_enabled = false
  monitoring_interval          = 0

  create_db_option_group    = false
  create_db_parameter_group = true
  parameter_group_name      = "${var.db_identifier}-pg"
  parameter_group_use_name_prefix = false

  parameters = [
    {
      name         = "max_connections"
      value        = tostring(var.db_max_connections)
      apply_method = "pending-reboot"
    },
    {
      name         = "log_min_duration_statement"
      value        = "1000"
      apply_method = "immediate"
    }
  ]

  tags = {
    Name        = var.db_identifier
    Terraform   = "true"
    Environment = var.environment
  }
}
