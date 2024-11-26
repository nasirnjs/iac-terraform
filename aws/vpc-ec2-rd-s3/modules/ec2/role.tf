# IAM Role for EC2 to assume the policy
resource "aws_iam_role" "ec2_role" {
  name               = "ec2-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# IAM Policy for EC2 to access the S3 bucket
resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "EC2-S3-Policy"
  description = "Allow EC2 instances to access the S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Action    = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:ListAllMyBuckets"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]  
      }
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_s3_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

# IAM Instance Profile to attach to EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
