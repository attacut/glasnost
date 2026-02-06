locals {
  env = get_env("ENV", "dev")
  
  aws_region = get_env("AWS_REGION", "ap-southeast-1")
  
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
  backend = "s3"
  config = {
    bucket         = "terraform-state-3001bd9d"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    #dynamodb_table = "glasnost-terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
