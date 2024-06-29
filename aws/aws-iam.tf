provider "aws" {
  region     = "us-east-2"
}
resource "aws_iam_user" "admin-user" {
    name = "nasir2"
    tags = {
      description = "Technical Team Lead"
    }
}
resource "aws_iam_policy" "policy" {
  name        = "admin-policy"
  description = "A admin policy"
  policy      = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "*",
                "Resource": "*"
            }
        ]
    }
    EOF
}
resource "aws_iam_user_policy_attachment" "nasir-admin-attach" {
  user       = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.policy.arn
}

