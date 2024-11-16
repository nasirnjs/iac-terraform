resource "aws_db_instance" "mysql_rds" {
  identifier          = format("%s-rds", var.environment)
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = var.instance_class
  allocated_storage   = 20
  storage_encrypted   = true
  username            = var.db_user_name
  password            = var.db_password
  db_name             = var.db_name
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  vpc_security_group_ids = [var.rds_sg_id]  # Use the passed variable

  tags = {
    Name        = format("%s-my-rds", var.environment)
    Environment = var.environment
  }

  depends_on = [
    aws_db_subnet_group.rds_subnet_group
  ]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = format("%s-rds-subnet-group", var.environment)
  subnet_ids  = [
    var.private_subnet_one_id,
    var.private_subnet_two_id
  ]

  tags = {
    Name        = format("%s-rds-subnet-group", var.environment)
    Environment = var.environment
  }
}
