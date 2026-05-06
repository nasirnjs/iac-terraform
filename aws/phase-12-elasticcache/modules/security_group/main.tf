# Security group for Redis
resource "aws_security_group" "redis_sg" {
  vpc_id = var.vpc_id
  name   = "redis_security_group"
  tags = {
    Name        = format("%s_redis_sg", var.environment)
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_redis_ipv4" {
  security_group_id = aws_security_group.redis_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Replace with specific trusted CIDR block for better security
  from_port         = 6379
  ip_protocol       = "tcp"
  to_port           = 6379
  description       = "Allow Redis traffic from any IPv4 address"
}

# NOTE on Egress rules: By default, AWS creates an ALLOW ALL egress rule when creating a new Security Group inside of a VPC.
# resource "aws_vpc_security_group_egress_rule" "rds_egress" {
#   security_group_id = aws_security_group.redis_sg.id
#   from_port        = 0
#   to_port          = 0
#   protocol         = "-1"
#   cidr_blocks      = ["0.0.0.0/0"]
#   ipv6_cidr_blocks = ["::/0"] # Ensure this is required; consider restricting it to specific destinations.
# }

# Security group for EC2/ALB
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  name   = "ym_ec2_sg"
  tags = {
    Name        = format("%s-ym_ec2_sg", var.environment)
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Replace with specific trusted CIDR block for better security
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description       = "Allow HTTP traffic from any IPv4 address"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Replace with specific trusted CIDR block for better security
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Allow HTTPS traffic from any IPv4 address"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv6         = "::/0" # Replace with specific trusted IPv6 block for better security
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Allow HTTPS traffic from any IPv6 address"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound IPv4 traffic"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
  description       = "Allow all outbound IPv6 traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Replace with specific trusted CIDR block for better security
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Allow SSH access from any IPv4 address"
}

# NOTE on Egress rules: By default, AWS creates an ALLOW ALL egress rule when creating a new Security Group inside of a VPC.
# resource "aws_vpc_security_group_egress_rule" "ec2_egress" {
#   security_group_id = aws_security_group.ec2_sg.id
#   ip_protocol       = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
#   ipv6_cidr_blocks  = ["::/0"]
#   description       = "Allow all outbound traffic"
# }
