output "bh_role" {
  value = aws_iam_role.eks_describe_role
}

output "bh_instance" {
  value = aws_instance.bh_instance
}
output "aws_sg_ssh" {
  value = aws_security_group.allow_ssh.id
}
