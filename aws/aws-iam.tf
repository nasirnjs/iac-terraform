
resource "aws_iam_user" "admin-user" {
    name = "anim"
    tags = {
      description = "Technical Team Lead"
    }
}
resource "aws_iam_policy" "policy" {
  name        = "admin-policy"
  description = "A admin policy"
  policy      = file("admin-policy.json")
}
resource "aws_iam_user_policy_attachment" "nasir-admin-attach" {
  user       = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.policy.arn
}

