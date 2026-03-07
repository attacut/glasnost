variable "vpc_id" {
  description = "VPC ID where Network ACLs will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet names to IDs"
  type        = map(string)
}

variable "network_acls" {
  description = "List of Network ACL configurations"
  type = list(object({
    name         = string
    subnet_names = list(string)
    ingress_rules = list(object({
      rule_no    = number
      protocol   = string
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))
    egress_rules = list(object({
      rule_no    = number
      protocol   = string
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
