locals {
  ingress_rules = flatten([
    for sg in var.security_groups : [
      for rule in sg.ingress_rules : {
        key                        = "${sg.name}-ingress-${rule.description}"
        sg_name                    = sg.name
        description                = rule.description
        ip_protocol                = rule.ip_protocol
        from_port                  = rule.from_port
        to_port                    = rule.to_port
        cidr_ipv4                  = rule.cidr_ipv4
        referenced_security_group_id = rule.referenced_security_group_id
      }
    ]
  ])

  egress_rules = flatten([
    for sg in var.security_groups : [
      for rule in sg.egress_rules : {
        key                        = "${sg.name}-egress-${rule.description}"
        sg_name                    = sg.name
        description                = rule.description
        ip_protocol                = rule.ip_protocol
        from_port                  = rule.from_port
        to_port                    = rule.to_port
        cidr_ipv4                  = rule.cidr_ipv4
        referenced_security_group_id = rule.referenced_security_group_id
      }
    ]
  ])
}

resource "aws_security_group" "this" {
  for_each = { for sg in var.security_groups : sg.name => sg }

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = { for r in local.ingress_rules : r.key => r }

  security_group_id            = aws_security_group.this[each.value.sg_name].id
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.ip_protocol == "-1" ? null : each.value.from_port
  to_port                      = each.value.ip_protocol == "-1" ? null : each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  referenced_security_group_id = each.value.referenced_security_group_id

  tags = merge(
    var.tags,
    {
      Name = each.value.key
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = { for r in local.egress_rules : r.key => r }

  security_group_id            = aws_security_group.this[each.value.sg_name].id
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.ip_protocol == "-1" ? null : each.value.from_port
  to_port                      = each.value.ip_protocol == "-1" ? null : each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  referenced_security_group_id = each.value.referenced_security_group_id

  tags = merge(
    var.tags,
    {
      Name = each.value.key
    }
  )
}
