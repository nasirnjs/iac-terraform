# Create an IAM User
resource "aws_iam_user" "console_user" {
  name = "console-user"
  tags = {
    Environment = "Dev"
  }
}

# Create a Login Profile for the User (for AWS Console access)
resource "aws_iam_user_login_profile" "console_user_login" {
  user                   = aws_iam_user.console_user.name
  password_reset_required = true
}

# Output the password (Sensitive)
output "password" {
  value     = aws_iam_user_login_profile.console_user_login.password
  sensitive = true
}

# Create an IAM Group (DevOps)
resource "aws_iam_group" "devops" {
  name = "devops-ug"
}

# Attach the AdministratorAccess policy to the DevOps group
resource "aws_iam_group_policy_attachment" "devops_admin_policy" {
  group      = aws_iam_group.devops.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Add console-user to the devops group
resource "aws_iam_group_membership" "devops_group_membership" {
  name  = "devops-ug-mbrp" 
  group = aws_iam_group.devops.name
  users = [aws_iam_user.console_user.name]
}
