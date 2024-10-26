data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "default" {}
data "aws_elb_hosted_zone_id" "current" {}
data "aws_partition" "current" {}