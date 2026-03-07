variable "vpc_id" {
  description = "VPC ID to attach the Internet Gateway to"
  type        = string
}

variable "name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
