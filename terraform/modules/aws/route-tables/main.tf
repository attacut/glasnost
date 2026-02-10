resource "aws_route_table" "this" {
  for_each = { for rt in var.route_tables : rt.name => rt }

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

resource "aws_route_table_association" "this" {
  for_each = { for rt in var.route_tables : rt.name => rt }

  subnet_id      = var.subnet_ids[each.value.subnet_name]
  route_table_id = aws_route_table.this[each.key].id
}
