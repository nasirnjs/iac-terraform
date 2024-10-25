#vpc-cni
data "tls_certificate" "oidc_tls" {
  url = aws_eks_cluster.cluster_quickops.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster_quickops.identity[0].oidc[0].issuer
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}



data "aws_iam_policy_document" "vpc_cni_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }
  }
  depends_on = [aws_iam_openid_connect_provider.oidc_provider]

}


resource "aws_iam_role" "vpc_cni_role" {
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_role_policy.json
  name               = format("%s-vpc-cni-role", var.cluster_name)

  depends_on = [data.aws_iam_policy_document.vpc_cni_assume_role_policy]
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}

resource "aws_iam_role_policy_attachment" "vpc_cni_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni_role.name

  depends_on = [aws_iam_role.vpc_cni_role]

}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = aws_eks_cluster.cluster_quickops.name
  addon_name               = "vpc-cni"
  service_account_role_arn = aws_iam_role.vpc_cni_role.arn

  configuration_values = jsonencode({
  
  "enableNetworkPolicy": "true"

  })

  depends_on = [aws_eks_cluster.cluster_quickops, aws_iam_role.vpc_cni_role]
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}
#ebs-driver
resource "aws_eks_addon" "ebs-csi" {
  cluster_name = aws_eks_cluster.cluster_quickops.name
  addon_name   = "aws-ebs-csi-driver"
  //addon_version = local.env[addon_version_csi]
  resolve_conflicts = "PRESERVE"
}