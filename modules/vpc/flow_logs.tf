locals {
  environment = var.project_info[0]
}

resource "aws_flow_log" "this" {
  count           = local.environment == "prod" ? 1 : 0
  iam_role_arn    = aws_iam_role.this[0].arn
  log_destination = aws_cloudwatch_log_group.this[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "this" {
  count = local.environment == "prod" ? 1 : 0
  name  = "${local.resource_name_prefix}-vpc-flow-logs"
}

data "aws_iam_policy_document" "assume_role" {
  count = local.environment == "prod" ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  count              = local.environment == "prod" ? 1 : 0
  name               = "${local.resource_name_prefix}-vpc-flow-logs"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

data "aws_iam_policy_document" "this" {
  count = local.environment == "prod" ? 1 : 0
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "this" {
  count  = local.environment == "prod" ? 1 : 0
  name   = "${local.resource_name_prefix}-vpc-flow-logs"
  role   = aws_iam_role.this[0].id
  policy = data.aws_iam_policy_document.this[0].json
}