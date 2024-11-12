resource "aws_security_group" "ec2_sg" {
   name      = format("%s-ec2-sg", var.environment)
   vpc_id = aws_vpc.ec2_vpc.id

   ingress {
      description = "ingress_rule_1"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
   
   ingress {
      description = "ingress_rule_2"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
      description = "ingress_rule_3"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
  # Allow outbound traffic (0.0.0.0/0)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
      Name        = format("%s-ec2-security-group", var.environment)
      Environment = var.environment
   }
}
# Create a Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.ec2_vpc.id

  # Allow inbound access to MySQL (port 3306) from EC2 instances in the private subnet
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.rds_private_subnet.cidr_block]  # Only allow traffic from private subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = format("%s-rds-sg", var.environment)
    Environment = var.environment
  }
}
