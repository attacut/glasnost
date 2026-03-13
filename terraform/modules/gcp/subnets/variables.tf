variable "network_self_link" {
  description = "Self link of the VPC network"
  type        = string
}

variable "subnets" {
  description = "List of subnet configurations"
  type = list(object({
    name                     = string
    region                   = string
    ip_cidr_range            = string
    private_ip_google_access = optional(bool, true)
    enable_flow_logs         = optional(bool, false)
    secondary_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  default = []
}
