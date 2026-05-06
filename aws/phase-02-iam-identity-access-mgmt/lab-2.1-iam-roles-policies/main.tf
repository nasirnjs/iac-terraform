# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get a subnet from Default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# IAM Role with EC2 trust policy
resource "aws_iam_role" "ec2_s3_read" {
  name = "ec2-s3-read-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Attach AWS managed S3 read-only policy to the role
resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.ec2_s3_read.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Instance profile to bind role to EC2
resource "aws_iam_instance_profile" "ec2_s3_read" {
  name = "ec2-s3-read-profile"
  role = aws_iam_role.ec2_s3_read.name
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name          = "single-instance"
  instance_type = "t3.micro"

  # Automatically use first default subnet
  subnet_id = data.aws_subnets.default.ids[0]

  #key_name = "user1"

  monitoring = true

  # Attach IAM instance profile so the EC2 can read from S3
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_read.name

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}