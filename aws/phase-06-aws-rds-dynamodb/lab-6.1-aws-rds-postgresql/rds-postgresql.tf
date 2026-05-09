locals {
  rds_template_defaults = {
    production = {
      multi_az                     = true
      performance_insights_enabled = true
      monitoring_interval          = 60
      skip_final_snapshot          = false
      auto_minor_version_upgrade   = true
    }
    dev-test = {
      multi_az                     = false
      performance_insights_enabled = false
      monitoring_interval          = 0
      skip_final_snapshot          = true
      auto_minor_version_upgrade   = true
    }
    sandbox = {
      multi_az                     = false
      performance_insights_enabled = false
      monitoring_interval          = 0
      skip_final_snapshot          = true
      auto_minor_version_upgrade   = true
    }
  }

  rds_template = local.rds_template_defaults[var.db_template]
}

module "rds_postgresql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = var.db_identifier

  engine               = "postgres"
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
  port                = 5432

  manage_master_user_password = false

  multi_az            = local.rds_template.multi_az
  publicly_accessible = false

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  vpc_security_group_ids = [module.rds_postgresql_sg.security_group_id]

  backup_retention_period    = var.db_backup_retention_period
  skip_final_snapshot        = local.rds_template.skip_final_snapshot
  deletion_protection        = var.db_deletion_protection
  auto_minor_version_upgrade = local.rds_template.auto_minor_version_upgrade
  apply_immediately          = true

  performance_insights_enabled = local.rds_template.performance_insights_enabled
  monitoring_interval          = local.rds_template.monitoring_interval

  create_db_option_group          = false
  create_db_parameter_group       = true
  parameter_group_name            = "${var.db_identifier}-pg"
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

module "rds_postgresql_replica" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  count = var.db_create_read_replica ? var.db_read_replica_count : 0

  identifier          = "${var.db_identifier}-replica-${count.index + 1}"
  replicate_source_db = module.rds_postgresql.db_instance_identifier

  engine               = "postgres"
  engine_version       = var.db_engine_version
  family               = var.db_family
  major_engine_version = var.db_major_engine_version
  instance_class       = coalesce(var.db_read_replica_instance_class, var.db_instance_class)

  storage_type      = "gp3"
  storage_encrypted = true

  port                = 5432
  publicly_accessible = false

  # Replicas inherit credentials and db subnet group from the source
  create_db_subnet_group    = false
  create_db_option_group    = false
  create_db_parameter_group = false

  vpc_security_group_ids = [module.rds_postgresql_sg.security_group_id]

  multi_az                   = false
  backup_retention_period    = 0
  skip_final_snapshot        = true
  deletion_protection        = var.db_deletion_protection
  auto_minor_version_upgrade = local.rds_template.auto_minor_version_upgrade
  apply_immediately          = true

  performance_insights_enabled = local.rds_template.performance_insights_enabled
  monitoring_interval          = local.rds_template.monitoring_interval

  tags = {
    Name        = "${var.db_identifier}-replica-${count.index + 1}"
    Terraform   = "true"
    Environment = var.environment
    Role        = "read-replica"
  }
}
