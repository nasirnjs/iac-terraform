# security group for application load balancer / ec2 Instance
resource "aws_security_group" "redis_sg" {
  vpc_id            = var.vpc_id
  name              = "redish_security_group"
  tags = {
    Name            = format("%s_redis_sg", var.environment)
    Environment     = var.environment
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_redis_ipv4" {
  security_group_id = aws_security_group.redis_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6379
  ip_protocol       = "tcp"
  to_port           = 6379
}

# security group for application load balancer / ec2 Instance

resource "aws_security_group" "ec2_sg" {
  vpc_id            = var.vpc_id
  name              = "ym_ec2_sg"
  tags = {
    Name            = format("%s-ym_ec2_sg", var.environment)
    Environment     = var.environment
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

# allow ssh
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.ec2_sg.id 
  cidr_ipv4         = "0.0.0.0/0"      
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


# # security group for application load balancer / ec2 Instance
# resource "aws_security_group" "redis_sg" {
#   vpc_id            = var.vpc_id
#   name              = "redish_security_group"
#   tags = {
#     Name            = format("%s_redis_sg", var.environment)
#     Environment     = var.environment
#   }
# }
# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.redis_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
#   security_group_id = aws_security_group.redis_sg.id
#   cidr_ipv6         = "::/0"
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.redis_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1"
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
#   security_group_id = aws_security_group.redis_sg.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1"
# }

# # allow ssh
# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
#   security_group_id = aws_security_group.redis_sg.id 
#   cidr_ipv4         = "0.0.0.0/0"      
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }


# # Aurora MySQL cluster security group

# resource "aws_security_group" "aurora_mysql" {
#   name        = "aurora_mysql_sg"
#   vpc_id            = var_vpc_id
#   description = "Security group for Aurora MySQL Cluster"

#   tags = {
#     Name = "aurora_mysql_sg"
#   }

#   ingress {
#     description = "MYSQL/Aurora"
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }