include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/aws/vpc"
}

inputs = {
  vpc_name = "glasnost-1"
  vpc_cidr = "172.16.0.0/16"

  tags = {
    Environment = "dev"
    Project     = "glasnost"
  }
}
