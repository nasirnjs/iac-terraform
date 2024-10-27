# Common Data source to get the OIDC issuer's TLS certificate for the EKS cluster
data "tls_certificate" "buddy_oidc" {
  url = aws_eks_cluster.buddy_eks.identity[0].oidc[0].issuer
}

# Commonm IAM OpenID Connect provider for the EKS cluster
resource "aws_iam_openid_connect_provider" "buddy_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.buddy_oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.buddy_eks.identity[0].oidc[0].issuer
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}

# IAM policy document for assuming the role
data "aws_iam_policy_document" "buddy_cni_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.buddy_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.buddy_oidc_provider.arn]
      type        = "Federated"
    }
  }
  depends_on = [ aws_iam_openid_connect_provider.buddy_oidc_provider ]
}
# IAM role for the vpc-cni addon
resource "aws_iam_role" "vpc_cni_role" {
  assume_role_policy = data.aws_iam_policy_document.buddy_cni_role_policy.json
  name               = format("%s-vpc-cni-role", var.cluster_name)
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}
# Attach the Amazon EKS CNI policy to the IAM role
resource "aws_iam_role_policy_attachment" "vpc_cni_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni_role.name
}
# addons install
resource "aws_eks_addon" "buddy_vpc_cni" {
  cluster_name                = aws_eks_cluster.buddy_eks.name
  addon_name                  = "vpc-cni"
  service_account_role_arn = aws_iam_role.vpc_cni_role.arn
  configuration_values = jsonencode({
  
  "enableNetworkPolicy": "true"
})
  depends_on = [aws_eks_cluster.buddy_eks, aws_iam_role.vpc_cni_role]
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}
############## EBS CSI Driver ##################

# IAM policy document for assuming the role for EBS CSI Driver
data "aws_iam_policy_document" "buddy_ebs_csi_driver_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.buddy_oidc_provider.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.buddy_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.buddy_oidc_provider.arn]
      type        = "Federated"
    }
  }
  depends_on = [aws_iam_openid_connect_provider.buddy_oidc_provider]
}

# IAM role for the Amazon EBS CSI Driver addon
resource "aws_iam_role" "ebs_csi_driver_role" {
  assume_role_policy = data.aws_iam_policy_document.buddy_ebs_csi_driver_role_policy.json
  name               = format("%s-ebs-csi-driver-role", var.cluster_name)
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}

# Attach the Amazon EBS CSI policy to the IAM role
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver_role.name
}

# Addon installation for Amazon EBS CSI Driver
resource "aws_eks_addon" "buddy_ebs_csi" {
  cluster_name                = aws_eks_cluster.buddy_eks.name
  addon_name                  = "aws-ebs-csi-driver"
  service_account_role_arn    = aws_iam_role.ebs_csi_driver_role.arn

  depends_on = [aws_eks_node_group.memory_optimize_group1, aws_iam_role.ebs_csi_driver_role]
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
  
}