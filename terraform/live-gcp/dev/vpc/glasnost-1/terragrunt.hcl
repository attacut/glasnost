include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/gcp/vpc"
}

inputs = {
  project_id   = "glasnost-dev"
  vpc_name     = "glasnost-1"
  routing_mode = "REGIONAL"
}
