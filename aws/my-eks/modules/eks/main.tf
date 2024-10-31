resource "aws_security_group" "allow_sg_bh" {
  name        = format("%s-allow-bastionhost-sg", var.cluster_name)
  vpc_id      = var.bh_vpc_id
  description = "Allow bastion host security group traffic"
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }

  ingress {
    from_port         = 443
    to_port           = 443
    protocol          = "tcp"
    security_groups   = [var.aws_sg_ssh]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##
resource "aws_iam_role" "buddy-eks-role" {
  name = format("%s-buddy-eks-role",var.cluster_name)
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}
# 
resource "aws_iam_role_policy_attachment" "buddy-eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.buddy-eks-role.name
}

resource "aws_eks_cluster" "buddy_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.buddy-eks-role.arn

  vpc_config {
    security_group_ids      = [aws_security_group.allow_sg_bh.id]
    endpoint_private_access = true
    endpoint_public_access  = false

    subnet_ids = [
      var.subnet_id_private_1,
      var.subnet_id_private_2
    ]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.buddy-eks-AmazonEKSClusterPolicy]
}