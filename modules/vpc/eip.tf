resource "aws_eip" "main" {

  domain = "vpc"
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name         = "${local.resource_name_prefix}-eip"
    Environment  = var.project_info[0]
    ResourceType = "EIP"
    Developer    = var.project_info[1]
  }

}