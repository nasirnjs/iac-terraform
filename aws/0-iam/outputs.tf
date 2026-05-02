output "access_key_id" {
  value = module.devops_user.unique_id
}

output "secret_access_key" {
  value     = module.devops_user.access_key_secret
  sensitive = true
}
output "console_signin_link" {
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
}