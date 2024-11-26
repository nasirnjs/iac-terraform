resource "aws_s3_bucket" "ym_ecom_images" {
  bucket = var.bucket_name
  tags = {
    Name        = "Ecommerce Images Bucket"
    Environment = var.environment
  }
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

