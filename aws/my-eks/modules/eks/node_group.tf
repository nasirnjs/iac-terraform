resource "aws_iam_role" "private_node_group_role" {
  name = format("%s-eks-node-group-role", var.cluster_name)

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "private_node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.private_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "private_node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.private_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "private_node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.private_node_group_role.name
}

# private node group
resource "aws_eks_node_group" "memory_optimize_group1" {
  cluster_name    = aws_eks_cluster.buddy_eks.name
  node_group_name = format("%s-private_node_group1", var.cluster_name)
  node_role_arn   = aws_iam_role.private_node_group_role.arn

  subnet_ids      = [
    var.subnet_id_private_1,
    var.subnet_id_private_2
  ]

  capacity_type = var.capacity_type
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
     role = "general"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.private_node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.private_node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.private_node-AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.buddy_eks
  ]


  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
