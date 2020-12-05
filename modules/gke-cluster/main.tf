#=======================================================
# Data Sources
#=======================================================
data "google_container_engine_versions" "gkeversion" {
  location = var.location
  project  = var.id-project
}

data "google_compute_network" "vpc-cluster" {
  name    = var.name-vpc-cluster
  project = var.id-project
}

data "google_compute_subnetwork" "subnet-cluster" {
  name    = var.name-subnet-cluster
  project = var.id-project
}

#=======================================================
# Local Variables
#=======================================================
locals {
  name-prefix           = lower(var.name-prefix)
  latest-master-version = data.google_container_engine_versions.gkeversion.latest_master_version
  latest-node-version   = data.google_container_engine_versions.gkeversion.latest_node_version
  k8s-master-version    = var.config-gke-cluster.k8s-master-version != "latest" ? var.config-gke-cluster.k8s-master-version : local.latest-master-version
}

#=======================================================
# GKE Cluster
#=======================================================
resource "google_container_cluster" "gke-cluster" {
  name       = "${var.name-prefix}${var.config-gke-cluster.name-suffix}"
  location   = var.location
  network    = data.google_compute_network.vpc-cluster.self_link
  subnetwork = data.google_compute_subnetwork.subnet-cluster.self_link

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  min_master_version = local.k8s-master-version

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = var.k8s-username
    password = var.k8s-password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
   
  ip_allocation_policy {
    cluster_secondary_range_name  = "${local.name-prefix}${var.config-gke-cluster.cluster-secondary-name-suffix}"
    services_secondary_range_name = "${local.name-prefix}${var.config-gke-cluster.cluster-service-name-suffix}"
  }

}

#=======================================================
# GKE Cluster Node Pool
#=======================================================
resource "google_container_node_pool" "gke-node-pool" {
  for_each           = var.config-gke-nodepools
  name               = "${var.name-prefix}${each.value["name-suffix"]}"
  location           = var.location
  cluster            = google_container_cluster.gke-cluster.name
  version            = each.value["k8s-node-version"] != "latest" ? each.value["k8s-node-version"] : local.latest-node-version
  initial_node_count = 1

  management {
    auto_repair  = false
    auto_upgrade = false
  }

  node_config {
    preemptible  = each.value["preemptible"]
    machine_type = each.value["type-machine"]
    disk_size_gb = each.value["size-disk"]
    disk_type    = each.value["type-disk"]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}
