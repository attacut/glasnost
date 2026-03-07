variable "vpc_id" {
  description = "VPC ID where route tables will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet names to IDs"
  type        = map(string)
}

variable "route_tables" {
  description = "List of route tables configuration"
  type = list(object({
    name        = string
    subnet_name = string
    routes = optional(list(object({
      cidr_block                = string
      gateway_id                = optional(string)
      nat_gateway_id            = optional(string)
      network_interface_id      = optional(string)
      transit_gateway_id        = optional(string)
      vpc_peering_connection_id = optional(string)
    })), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
