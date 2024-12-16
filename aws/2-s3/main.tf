resource "aws_s3_bucket" "ym-devops-tf" {
  bucket = "yourmentors-tf"

  tags = {
    Name        = "YourMentors TF Doc"
    Environment = "Dev"
  }
}