resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.env}-${var.project}-med-iac-state"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
