include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/gcp/subnets"
}

dependency "vpc" {
  config_path = "../../vpc/glasnost-1"

  mock_outputs = {
    vpc_self_link = "projects/glasnost-dev/global/networks/glasnost-1"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  network_self_link = dependency.vpc.outputs.vpc_self_link

  subnets = [
    {
      name          = "glasnost-1-nodes"
      region        = "asia-southeast1"
      ip_cidr_range = "10.0.0.0/20"
      secondary_ranges = [
        {
          range_name    = "pods"
          ip_cidr_range = "10.4.0.0/14"
        },
        {
          range_name    = "services"
          ip_cidr_range = "10.8.0.0/20"
        }
      ]
    }
  ]
}
