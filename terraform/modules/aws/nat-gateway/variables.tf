variable "subnet_ids" {
  description = "Map of subnet names to IDs (must be public subnets)"
  type        = map(string)
}

variable "nat_gateways" {
  description = "List of NAT Gateway configurations"
  type = list(object({
    name        = string
    subnet_name = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
