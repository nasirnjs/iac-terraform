module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.12.0"

  bucket = var.bucket_name

  # Recommended settings
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # THIS IS THE IMPORTANT PART
  attach_policy = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })

  # Only disable blocks if truly needed
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
