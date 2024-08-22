# GCP Global IPs
resource "google_compute_global_address" "explorer-app" {
  name = "explorer-app-ip"
}

resource "google_compute_global_address" "explorer-api" {
  name = "explorer-api-ip"
}

resource "google_compute_global_address" "portal" {
  name = "portal-ip"
}

resource "google_compute_global_address" "server" {
  name = "server-ip"
}

resource "google_compute_global_address" "grafana" {
  name = "grafana-ip"
}

resource "google_compute_global_address" "external-node" {
  name = "external-node-ip"
}

resource "google_compute_global_address" "en-grafana" {
  name = "en01-grafana-ip"
}

data "google_compute_global_address" "explorer-app" {
  name = google_compute_global_address.explorer-app.name

  depends_on = [
    google_compute_global_address.explorer-app
  ]
}

data "google_compute_global_address" "explorer-api" {
  name = google_compute_global_address.explorer-api.name

  depends_on = [
    google_compute_global_address.explorer-api
  ]
}

data "google_compute_global_address" "portal" {
  name = google_compute_global_address.portal.name

  depends_on = [
    google_compute_global_address.portal
  ]
}

data "google_compute_global_address" "server" {
  name = google_compute_global_address.server.name

  depends_on = [
    google_compute_global_address.server
  ]
}

data "google_compute_global_address" "grafana" {
  name = google_compute_global_address.grafana.name

  depends_on = [
    google_compute_global_address.grafana
  ]
}

data "google_compute_global_address" "external-node" {
  name = google_compute_global_address.external-node.name

  depends_on = [
    google_compute_global_address.external-node
  ]
}

data "google_compute_global_address" "en-grafana" {
  name = google_compute_global_address.en-grafana.name

  depends_on = [
    google_compute_global_address.en-grafana
  ]
}
