module "rds_mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = var.db_identifier

  engine               = var.db_engine
  engine_version       = var.db_engine_version
  family               = var.db_family
  major_engine_version = var.db_major_engine_version
  instance_class       = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name             = var.db_name
  username            = var.db_username
  password_wo         = var.db_password
  password_wo_version = var.db_password_version
  port                = 3306

  manage_master_user_password = false

  multi_az            = false
  publicly_accessible = false

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  vpc_security_group_ids = [module.rds_mysql_sg.security_group_id]

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
      apply_method = "immediate"
    },
    {
      name         = "character_set_server"
      value        = "utf8mb4"
      apply_method = "pending-reboot"
    },
    {
      name         = "collation_server"
      value        = "utf8mb4_unicode_ci"
      apply_method = "pending-reboot"
    }
  ]

  tags = {
    Name        = var.db_identifier
    Terraform   = "true"
    Environment = var.environment
  }
}
