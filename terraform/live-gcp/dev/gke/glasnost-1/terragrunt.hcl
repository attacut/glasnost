include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/gcp/gke"
}

dependency "vpc" {
  config_path = "../../vpc/glasnost-1"

  mock_outputs = {
    vpc_self_link = "projects/glasnost-dev/global/networks/glasnost-1"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "subnets" {
  config_path = "../../subnets/glasnost-1"

  mock_outputs = {
    subnet_self_links = {
      "glasnost-1-nodes" = "projects/glasnost-dev/regions/asia-southeast1/subnetworks/glasnost-1-nodes"
    }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  project_id   = "glasnost-dev"
  cluster_name = "glasnost-1"
  location     = "asia-southeast1"

  # Network
  network_self_link             = dependency.vpc.outputs.vpc_self_link
  subnet_self_link              = dependency.subnets.outputs.subnet_self_links["glasnost-1-nodes"]
  pods_secondary_range_name     = "pods"
  services_secondary_range_name = "services"

  # Private cluster
  enable_private_nodes    = true
  enable_private_endpoint = false
  master_ipv4_cidr_block  = "172.16.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "All"
    }
  ]

  # Cilium + Istio
  enable_cilium      = true
  enable_istio       = false
  enable_gateway_api = true

  # Cluster
  release_channel     = "REGULAR"
  deletion_protection = true

  # Node pools
  node_pools = [
    {
      name           = "general"
      machine_type   = "e2-standard-4"
      node_count     = 2
      min_node_count = 1
      max_node_count = 5
      disk_size_gb   = 100
      disk_type      = "pd-ssd"
      labels = {
        role = "general"
      }
    }
  ]
}
