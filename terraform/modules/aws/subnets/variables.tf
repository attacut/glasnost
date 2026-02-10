variable "vpc_id" {
  description = "VPC ID where subnets will be created"
  type        = string
}

variable "subnets" {
  description = "List of subnets configuration"
  type = list(object({
    name = string
    cidr = string
    az   = string
    type = string # "public" or "private"
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
