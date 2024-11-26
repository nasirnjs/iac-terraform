resource "aws_s3_bucket" "ym_ecom_images" {
  bucket = var.bucket_name
  tags = {
    Name        = "Ecommerce Images Bucket"
    Environment = var.environment
  }
   
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.ym_ecom_images.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.ym_ecom_images.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.ym_ecom_images.arn}/*"
      }
    ]
  })
}

