resource "aws_security_group" "rds_sg" {
  name        = format("%s-rds-sg", var.environment)
  vpc_id      = var.vpc_id

  # Allow MySQL traffic from private subnets
  ingress {
    description = "Allow MySQL traffic from private subnets"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      var.private_subnet_one_id,
      var.private_subnet_two_id,
    ]
  }

  # Allow outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = format("%s-rds-sg", var.environment)
    Environment = var.environment
  }
}
