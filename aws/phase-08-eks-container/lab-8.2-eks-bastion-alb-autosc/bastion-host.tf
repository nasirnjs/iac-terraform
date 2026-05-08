# Security group for the bastion: SSH from a single allowed CIDR, all egress
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Bastion host SG (SSH from allowed CIDR)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_allowed_cidr]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-bastion-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# User data: install SSM agent, kubectl, helm, aws cli v2; pre-populate kubeconfig for `ubuntu`
locals {
  bastion_user_data = <<-EOT
    #!/bin/bash
    set -euxo pipefail

    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y unzip jq curl ca-certificates snapd

    # SSM agent (Ubuntu installs it via snap)
    snap install amazon-ssm-agent --classic || true
    snap start amazon-ssm-agent || true

    # AWS CLI v2
    curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
    unzip -q /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install --update

    # kubectl
    curl -sSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x /usr/local/bin/kubectl

    # helm
    curl -sSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

    # Pre-populate kubeconfig for the default ubuntu user
    sudo -u ubuntu -H bash -c 'aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}'
  EOT
}

module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "${var.project_name}-bastion"

  ami                         = var.bastion_ami_id
  instance_type               = var.bastion_instance_type
  key_name                    = var.bastion_key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  user_data                   = local.bastion_user_data
  user_data_replace_on_change = true

  metadata_options = {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device = {
    size      = 20
    type      = "gp3"
    encrypted = true
  }

  # Module-managed IAM role + instance profile
  create_iam_instance_profile = true
  iam_role_name               = "${var.project_name}-bastion-role"
  iam_role_use_name_prefix    = false
  iam_role_description        = "Role for the EKS bastion host (SSM + EKS describe)"
  iam_role_policies = {
    SSMCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Inline policy for eks:DescribeCluster (so `aws eks update-kubeconfig` works)
resource "aws_iam_role_policy" "bastion_eks_describe" {
  name = "${var.project_name}-bastion-eks-describe"
  role = module.bastion.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "eks:DescribeCluster",
        "eks:ListClusters"
      ]
      Resource = "*"
    }]
  })
}
