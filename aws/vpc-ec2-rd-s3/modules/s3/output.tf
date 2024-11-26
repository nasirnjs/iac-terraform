output "s3_bucket_arn" {
  value = aws_s3_bucket.ym_ecom_images.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.ym_ecom_images.bucket
}
