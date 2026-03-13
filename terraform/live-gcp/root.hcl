locals {
  env         = get_env("ENV", "dev")
  gcp_project = get_env("GCP_PROJECT_ID", "glasnost-dev")
  gcp_region  = get_env("GCP_REGION", "asia-southeast1")
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project = "${local.gcp_project}"
  region  = "${local.gcp_region}"
}
EOF
}

remote_state {
  backend = "gcs"
  config = {
    bucket = "glasnost-terraform-state-gcp"
    prefix = "${path_relative_to_include()}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
