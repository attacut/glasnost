locals {
  env = get_env("ENV", "dev")
  
  aws_region = get_env("AWS_REGION", "us-east-1")
  
  common_tags = {
    Environment = local.env
    ManagedBy   = "Terragrunt"
    Project     = "glasnost"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  
  default_tags {
    tags = ${jsonencode(local.common_tags)}
  }
}
EOF
}

remote_state {
  backend = "local"
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
