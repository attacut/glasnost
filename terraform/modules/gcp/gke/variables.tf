variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "Region or zone to deploy the cluster (region = regional cluster, zone = zonal cluster)"
  type        = string
}

variable "network_self_link" {
  description = "Self link of the VPC network"
  type        = string
}

variable "subnet_self_link" {
  description = "Self link of the subnet for the cluster nodes"
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Name of the secondary IP range for pods"
  type        = string
}

variable "services_secondary_range_name" {
  description = "Name of the secondary IP range for services"
  type        = string
}

# Private cluster
variable "enable_private_nodes" {
  description = "Whether nodes only have private IP addresses (no public IP)"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Whether the master endpoint is only accessible privately"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the master network (must be /28, e.g. 172.16.0.0/28)"
  type        = string
  default     = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks that are allowed to access the master endpoint"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

# Release channel
variable "release_channel" {
  description = "GKE release channel (RAPID, REGULAR, STABLE, or UNSPECIFIED)"
  type        = string
  default     = "REGULAR"

  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE", "UNSPECIFIED"], var.release_channel)
    error_message = "release_channel must be RAPID, REGULAR, STABLE, or UNSPECIFIED."
  }
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the cluster"
  type        = bool
  default     = true
}

# Cilium (GKE Dataplane V2)
variable "enable_cilium" {
  description = "Enable GKE Dataplane V2 (powered by Cilium) for networking and network policy"
  type        = bool
  default     = true
}

# Istio
variable "enable_istio" {
  description = "Enable Istio-related configurations (Gateway API, DNS). Note: Istio itself must be installed separately (e.g. via Helm)"
  type        = bool
  default     = false
}

variable "enable_gateway_api" {
  description = "Enable Gateway API on the cluster (used with Istio for ingress)"
  type        = bool
  default     = true
}

# Cloud DNS (for Istio multi-cluster)
variable "cluster_dns_provider" {
  description = "DNS provider for the cluster: PLATFORM_DEFAULT or CLOUD_DNS"
  type        = string
  default     = "PLATFORM_DEFAULT"

  validation {
    condition     = contains(["PLATFORM_DEFAULT", "CLOUD_DNS"], var.cluster_dns_provider)
    error_message = "cluster_dns_provider must be PLATFORM_DEFAULT or CLOUD_DNS."
  }
}

variable "cluster_dns_scope" {
  description = "DNS scope when using Cloud DNS: CLUSTER_SCOPE or VPC_SCOPE"
  type        = string
  default     = "CLUSTER_SCOPE"
}

variable "cluster_dns_domain" {
  description = "Custom DNS domain for the cluster (only used with Cloud DNS)"
  type        = string
  default     = "cluster.local"
}

# Node pools
variable "node_pools" {
  description = "List of node pool configurations"
  type = list(object({
    name             = string
    node_count       = optional(number, 1)
    min_node_count   = optional(number, 1)
    max_node_count   = optional(number, 3)
    machine_type     = optional(string, "e2-medium")
    disk_size_gb     = optional(number, 50)
    disk_type        = optional(string, "pd-standard")
    service_account  = optional(string, null)
    labels           = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = []
}
