output "bh_role" {
  value = aws_iam_role.eks_describe_role
}

output "bh_instance" {
  value = aws_instance.bh_instance
}