resource "aws_iam_role" "worker_node_group_role" {
  name = format("%s-eks-node-group-role", var.cluster_name)
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
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

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node_group_role.name
  depends_on = [aws_iam_role.worker_node_group_role]
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node_group_role.name
  depends_on = [aws_iam_role.worker_node_group_role]
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node_group_role.name
  depends_on = [aws_iam_role.worker_node_group_role]
}

# Optional: only if you want to "SSH" to your EKS nodes.
resource "aws_iam_role_policy_attachment" "amazon_ssm_managed_instance_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker_node_group_role.name
  depends_on = [aws_iam_role.worker_node_group_role]
}

# AmazonEBSCSIDriverPolicy
# resource "aws_iam_role_policy_attachment" "nodes_ebs_csi_driver_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#   role       = aws_iam_role.worker_node_group_role.name
#   depends_on = [aws_iam_role.worker_node_group_role]
# }



####################################################################################
#public node group

# resource "aws_eks_node_group" "public_nodegroup_1" {
#   cluster_name    = aws_eks_cluster.cluster_quickops.name
#   node_group_name = format("%s-public-nodegroup-1", var.cluster_name)
#   node_role_arn   = aws_iam_role.worker_node_group_role.arn

#   # Single subnet to avoid data transfer charges while testing.
#   subnet_ids = [
#     module.VPC.subnet_id_public_1.id,
#     module.VPC.subnet_id_public_2.id
#   ]

#   capacity_type  = "SPOT"
#   instance_types = ["t3.large"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   # labels = {
#   #   role = "general"
#   # }
#   tags = {
#     Name       = format("%s-nodegroup", var.cluster_name)
#     created_by = "quickops"
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.nodes_amazon_eks_worker_node_policy,
#     aws_iam_role_policy_attachment.nodes_amazon_eks_cni_policy,
#     aws_iam_role_policy_attachment.nodes_amazon_ec2_container_registry_read_only,
#     aws_eks_cluster.cluster_quickops
#   ]
# }



#####################################
#Private ng

resource "aws_eks_node_group" "private_nodegroup_1" {
  cluster_name    = aws_eks_cluster.cluster_quickops.name
  node_group_name = format("%s-private-nodegroup-1", var.cluster_name)
  node_role_arn   = aws_iam_role.worker_node_group_role.arn

  subnet_ids = [
      var.subnet_id_private_1,
      var.subnet_id_private_2
  ]

  capacity_type  = var.capacity_type
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  update_config {
    max_unavailable = 1
  }

  # labels = {
  #   role = "general"
  # }
  tags = {
    Name       = format("%s-nodegroup", var.cluster_name)
    created_by = "quickops"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_amazon_ec2_container_registry_read_only,
    aws_eks_cluster.cluster_quickops
  ]
}