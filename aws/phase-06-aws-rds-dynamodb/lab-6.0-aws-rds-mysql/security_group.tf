module "web_service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "web-service"
  description = "Security group for web service: HTTP/HTTPS/SSH open from internet"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "rds_mysql_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "rds-mysql-sg"
  description = "Allow MySQL 3306 from web service SG and remote admin IP"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "MySQL from web service SG"
      source_security_group_id = module.web_service_sg.security_group_id
    }
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL from remote admin"
      cidr_blocks = var.db_allowed_cidr
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
