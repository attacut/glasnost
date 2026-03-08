locals {
  routes = flatten([
    for rt in var.route_tables : [
      for route in rt.routes : {
        key                       = "${rt.name}-${route.cidr_block}"
        rt_name                   = rt.name
        cidr_block                = route.cidr_block
        gateway_id                = route.gateway_id
        nat_gateway_id            = route.nat_gateway_id
        network_interface_id      = route.network_interface_id
        transit_gateway_id        = route.transit_gateway_id
        vpc_peering_connection_id = route.vpc_peering_connection_id
      }
      if anytrue([
        route.gateway_id != null,
        route.nat_gateway_id != null,
        route.network_interface_id != null,
        route.transit_gateway_id != null,
        route.vpc_peering_connection_id != null,
      ])
    ]
  ])
}

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

resource "aws_route" "this" {
  for_each = { for r in local.routes : r.key => r }

  route_table_id            = aws_route_table.this[each.value.rt_name].id
  destination_cidr_block    = each.value.cidr_block
  gateway_id                = each.value.gateway_id
  nat_gateway_id            = each.value.nat_gateway_id
  network_interface_id      = each.value.network_interface_id
  transit_gateway_id        = each.value.transit_gateway_id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}

resource "aws_route_table_association" "this" {
  for_each = { for rt in var.route_tables : rt.name => rt }

  subnet_id      = var.subnet_ids[each.value.subnet_name]
  route_table_id = aws_route_table.this[each.key].id
}
