# ==================== DLM IAM Role ====================
data "aws_iam_policy_document" "dlm_lifecycle" {
  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:DescribeInstances",
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "dlm_lifecycle" {
  name = "${var.environment}-dlm-lifecycle-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "dlm.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "dlm_lifecycle" {
  name   = "${var.environment}-dlm-lifecycle-policy"
  role   = aws_iam_role.dlm_lifecycle.id
  policy = data.aws_iam_policy_document.dlm_lifecycle.json
}

# ==================== DLM Lifecycle Policy - Data Disk Only ====================
resource "aws_dlm_lifecycle_policy" "data_disk_backup" {
  description        = "Daily backup for Data EBS Volume - 7 days retention"
  execution_role_arn = aws_iam_role.dlm_lifecycle.arn
  state              = "ENABLED"

  policy_details {
    resource_types     = ["VOLUME"]
    resource_locations = ["CLOUD"]

    target_tags = {
      BackupPolicy = "daily-7days"
    }

    schedule {
      name = "Daily-Data-Disk-Backup"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["03:00"]   # UTC - Change as needed
      }

      retain_rule {
        count = 7
      }

      tags_to_add = {
        CreatedBy   = "DLM"
        VolumeType  = "DataDisk"
        Environment = var.environment
      }

      copy_tags = true
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
    Name        = "${var.environment}-data-disk-daily-backup"
  }
}