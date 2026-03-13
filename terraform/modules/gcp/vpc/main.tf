resource "google_compute_network" "this" {
  name                    = var.vpc_name
  description             = var.description
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

resource "google_compute_shared_vpc_host_project" "this" {
  count = var.shared_vpc_host ? 1 : 0

  project = var.project_id
}

resource "google_compute_shared_vpc_service_project" "this" {
  for_each = var.shared_vpc_host ? toset(var.service_project_ids) : []

  host_project    = var.project_id
  service_project = each.value

  depends_on = [google_compute_shared_vpc_host_project.this]
}

