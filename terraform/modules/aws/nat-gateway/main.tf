resource "aws_eip" "this" {
  for_each = var.enabled ? { for nat in var.nat_gateways : nat.name => nat } : {}

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${each.value.name}-eip"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = var.enabled ? { for nat in var.nat_gateways : nat.name => nat } : {}

  subnet_id     = var.subnet_ids[each.value.subnet_name]
  allocation_id = aws_eip.this[each.key].id

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )

  depends_on = [aws_eip.this]
}
