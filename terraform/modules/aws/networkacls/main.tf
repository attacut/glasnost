locals {
  ingress_rules = flatten([
    for acl in var.network_acls : [
      for rule in acl.ingress_rules : {
        key        = "${acl.name}-ingress-${rule.rule_no}"
        acl_name   = acl.name
        rule_no    = rule.rule_no
        protocol   = rule.protocol
        action     = rule.action
        cidr_block = rule.cidr_block
        from_port  = rule.from_port
        to_port    = rule.to_port
      }
    ]
  ])

  egress_rules = flatten([
    for acl in var.network_acls : [
      for rule in acl.egress_rules : {
        key        = "${acl.name}-egress-${rule.rule_no}"
        acl_name   = acl.name
        rule_no    = rule.rule_no
        protocol   = rule.protocol
        action     = rule.action
        cidr_block = rule.cidr_block
        from_port  = rule.from_port
        to_port    = rule.to_port
      }
    ]
  ])

  subnet_associations = flatten([
    for acl in var.network_acls : [
      for subnet_name in acl.subnet_names : {
        key         = "${acl.name}-${subnet_name}"
        acl_name    = acl.name
        subnet_name = subnet_name
      }
    ]
  ])
}

resource "aws_network_acl" "this" {
  for_each = { for acl in var.network_acls : acl.name => acl }

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

resource "aws_network_acl_rule" "ingress" {
  for_each = { for r in local.ingress_rules : r.key => r }

  network_acl_id = aws_network_acl.this[each.value.acl_name].id
  rule_number    = each.value.rule_no
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.protocol == "-1" ? null : each.value.from_port
  to_port        = each.value.protocol == "-1" ? null : each.value.to_port
}

resource "aws_network_acl_rule" "egress" {
  for_each = { for r in local.egress_rules : r.key => r }

  network_acl_id = aws_network_acl.this[each.value.acl_name].id
  rule_number    = each.value.rule_no
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.protocol == "-1" ? null : each.value.from_port
  to_port        = each.value.protocol == "-1" ? null : each.value.to_port
}

resource "aws_network_acl_association" "this" {
  for_each = { for a in local.subnet_associations : a.key => a }

  network_acl_id = aws_network_acl.this[each.value.acl_name].id
  subnet_id      = var.subnet_ids[each.value.subnet_name]
}