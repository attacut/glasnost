resource "google_container_cluster" "this" {
  name     = var.cluster_name
  location = var.location

  network    = var.network_self_link
  subnetwork = var.subnet_self_link

  # Remove the default node pool and manage node pools separately
  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  # Cilium: GKE Dataplane V2 (powered by Cilium)
  datapath_provider = var.enable_cilium ? "ADVANCED_DATAPATH_V2" : "LEGACY_DATAPATH"

  # Gateway API (required for Istio ingress gateway)
  dynamic "gateway_api_config" {
    for_each = var.enable_gateway_api ? [1] : []
    content {
      channel = "CHANNEL_STANDARD"
    }
  }

  # Network policy is managed by Cilium when Dataplane V2 is enabled
  dynamic "network_policy" {
    for_each = var.enable_cilium ? [] : [1]
    content {
      enabled = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = var.release_channel
  }

  # DNS config for Istio multi-cluster (optional, use Cloud DNS)
  dynamic "dns_config" {
    for_each = var.enable_istio && var.cluster_dns_provider == "CLOUD_DNS" ? [1] : []
    content {
      cluster_dns        = "CLOUD_DNS"
      cluster_dns_scope  = var.cluster_dns_scope
      cluster_dns_domain = var.cluster_dns_domain
    }
  }

  deletion_protection = var.deletion_protection

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

resource "google_container_node_pool" "this" {
  for_each = { for np in var.node_pools : np.name => np }

  name     = each.value.name
  cluster  = google_container_cluster.this.id
  location = var.location

  node_count = each.value.node_count

  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    image_type   = "COS_CONTAINERD"

    service_account = each.value.service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = each.value.labels
    taint  = each.value.taints

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
