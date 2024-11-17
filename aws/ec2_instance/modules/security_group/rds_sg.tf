# Fetch the CIDR blocks for the private subnets
data "aws_subnet" "private_subnet_one" {
  id = var.private_subnet_one_id
}

data "aws_subnet" "private_subnet_two" {
  id = var.private_subnet_two_id
}

resource "aws_security_group" "rds_subnet_group" {
  name        = format("%s-rds-sg", var.environment)
  vpc_id      = var.vpc_id

  # Allow MySQL traffic from private subnets
  ingress {
    description = "Allow MySQL traffic from private subnets"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [
      data.aws_subnet.private_subnet_one.cidr_block,
      data.aws_subnet.private_subnet_two.cidr_block,
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
