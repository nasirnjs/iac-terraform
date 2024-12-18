# S3 Bucket Resource
resource "aws_s3_bucket" "devops_buckets" {
  bucket = "yourmentors-devops-bucket" # Replace with your bucket name

  tags = {
    Name        = "YourMentors TF Bucket"
    Environment = "Dev"
  }
}

# Ownership Controls
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.devops_buckets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Public Access Block Settings
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.devops_buckets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ACL for Public Read Access
resource "aws_s3_bucket_acl" "public_read" {
  bucket = aws_s3_bucket.devops_buckets.id
  acl    = "public-read"
}

# Bucket Policy for Public Read Access
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.devops_buckets.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.devops_buckets.arn}/*"
      }
    ]
  })
}

# Output the Bucket Name and URL
output "bucket_name" {
  value = aws_s3_bucket.devops_buckets.bucket
}

# Bucket policy to grant write permissions to a specific IAM user
resource "aws_s3_bucket_policy" "write_permission_policy" {
  bucket = aws_s3_bucket.devops_buckets.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowSpecificUserWriteAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::699475925713:user/kader" # Replace with the IAM user's ARN
        },
        Action    = [
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource  = "${aws_s3_bucket.devops_buckets.arn}/*"
      }
    ]
  })
}
