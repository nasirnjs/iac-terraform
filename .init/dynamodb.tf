resource "aws_dynamodb_table" "terraform-state-lock" {
  name           = "${var.env}-${var.project}-med-iac-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
}
