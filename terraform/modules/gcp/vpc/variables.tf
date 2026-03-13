variable "project_id" {
  description = "GCP project ID that owns this VPC network"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "description" {
  description = "Description of the VPC network"
  type        = string
  default     = ""
}

variable "routing_mode" {
  description = "Routing mode for the VPC network (REGIONAL or GLOBAL)"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "routing_mode must be either REGIONAL or GLOBAL."
  }
}

variable "shared_vpc_host" {
  description = "Whether to enable this project as a Shared VPC host project"
  type        = bool
  default     = false
}

variable "service_project_ids" {
  description = "List of service project IDs to attach to this host project (only used when shared_vpc_host = true)"
  type        = list(string)
  default     = []
}
