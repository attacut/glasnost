locals {
  public_subnets  = [for s in var.subnets : s if s.type == "public"]
  private_subnets = [for s in var.subnets : s if s.type == "private"]
}

resource "aws_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = merge(
    var.tags,
    {
      Name = each.value.name
      Type = each.value.type
    }
  )
}