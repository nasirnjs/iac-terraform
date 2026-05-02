module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.12.0"

  bucket = var.bucket_name
  # Allow deletion of non-empty bucket
  #force_destroy = true

  # Recommended settings
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }

  # Only disable blocks if truly needed
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  attach_policy = true
  policy        = templatefile("${path.module}/policies/s3-public-read.json", {
    bucket_name = var.bucket_name
  })

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}