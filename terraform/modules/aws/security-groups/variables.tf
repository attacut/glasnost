variable "vpc_id" {
  description = "VPC ID where Security Groups will be created"
  type        = string
}

variable "security_groups" {
  description = "List of Security Group configurations"
  type = list(object({
    name        = string
    description = string
    ingress_rules = optional(list(object({
      description                  = string
      ip_protocol                  = string
      from_port                    = optional(number)
      to_port                      = optional(number)
      cidr_ipv4                    = optional(string)
      referenced_security_group_id = optional(string)
    })), [])
    egress_rules = optional(list(object({
      description                  = string
      ip_protocol                  = string
      from_port                    = optional(number)
      to_port                      = optional(number)
      cidr_ipv4                    = optional(string)
      referenced_security_group_id = optional(string)
    })), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
