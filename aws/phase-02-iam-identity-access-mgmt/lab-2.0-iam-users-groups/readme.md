
**Extract after apply**

```yaml
terraform output access_key_id
```

```yaml
terraform output -raw secret_access_key
```

```yaml
terraform output console_signin_link
```

Attach this existing AWS-managed policy to this user.
```yaml
resource "aws_iam_user_policy_attachment" "devops_user_s3_readonly" {
  user       = module.devops_user.iam_user_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
```