resource "aws_subnet" "public" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary]

  for_each          = var.public_subnets
  cidr_block        = each.key
  availability_zone = "${data.aws_region.current.name}${lookup(each.value, "az")}"
  vpc_id            = aws_vpc.main.id

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name         = "${local.resource_name_prefix}-public-${lookup(each.value, "az")}"
    Environment  = var.project_info[0]
    ResourceType = "SUBNET"
    Developer    = var.project_info[1]
  }
}

resource "aws_subnet" "private" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary]
  
  for_each          = var.private_subnets
  cidr_block        = each.key
  availability_zone = "${data.aws_region.current.name}${lookup(each.value, "az")}"
  vpc_id            = aws_vpc.main.id

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name                                                              = "${local.resource_name_prefix}-private-${lookup(each.value, "az")}"
    Environment                                                       = var.project_info[0]
    ResourceType                                                      = "SUBNET"
    Developer                                                         = var.project_info[1]
    "kubernetes.io/cluster/${local.resource_name_prefix}-cluster"     = "shared" //TODO: Remove dependency
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "secondary-private" {
  count             = var.enable_secondary_cidr ? var.subnet_count : 0
  cidr_block        = var.enable_secondary_cidr ? cidrsubnet(var.secondary_cidr_block, 5, count.index) : null
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name                                                          = "${local.resource_name_prefix}-secondary-private-${data.aws_availability_zones.available.names[count.index]}"
    Environment                                                   = var.project_info[0]
    ResourceType                                                  = "SUBNET"
    Developer                                                     = var.project_info[1]
    "kubernetes.io/cluster/${local.resource_name_prefix}-cluster" = "shared"
    "karpenter.sh/discovery"                                      = "${local.resource_name_prefix}-cluster"
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary]
}


resource "aws_subnet" "secondary-public" {
  count      = var.enable_secondary_cidr ? var.subnet_count : 0
  cidr_block = var.enable_secondary_cidr ? cidrsubnet(var.secondary_cidr_block, 5, count.index + 3) : null


  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name                                                          = "${local.resource_name_prefix}-secondary-public-${data.aws_availability_zones.available.names[count.index]}"
    Environment                                                   = var.project_info[0]
    ResourceType                                                  = "SUBNET"
    Developer                                                     = var.project_info[1]
    "kubernetes.io/cluster/${local.resource_name_prefix}-cluster" = "shared"
    "karpenter.sh/discovery"                                      = "${local.resource_name_prefix}-cluster"
  }

  depends_on = [aws_vpc_ipv4_cidr_block_association.secondary]
}