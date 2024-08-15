resource "google_compute_network" "gke-cluster-network" {
  name                    = var.cluster_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke-cluster-subnetwork" {
  name          = var.cluster_name
  ip_cidr_range = "10.150.0.0/16"
  region        = var.region
  network       = google_compute_network.gke-cluster-network.self_link
  secondary_ip_range {
    range_name    = "${var.cluster_name}-pods"
    ip_cidr_range = "10.32.0.0/16"
  }
  secondary_ip_range {
    range_name    = "${var.cluster_name}-services"
    ip_cidr_range = "10.64.0.0/16"
  }
}

data "google_compute_subnetwork" "gke-cluster-subnetwork" {
  name    = var.cluster_name
  region  = var.region
  project = var.project_id

  depends_on = [
    google_compute_subnetwork.gke-cluster-subnetwork
  ]
}
