# GCP Global IPs
resource "google_compute_global_address" "explorer-app" {
  name = var.explorer_app_ip_name
}

resource "google_compute_global_address" "explorer-api" {
  name = var.explorer_api_ip_name
}

resource "google_compute_global_address" "portal" {
  name = var.portal_ip_name
}

resource "google_compute_global_address" "server" {
  name = var.server_ip_name
}

resource "google_compute_global_address" "grafana" {
  name = var.grafana_ip_name
}

resource "google_compute_global_address" "external-node" {
  name = var.external_node_ip_name
}

resource "google_compute_global_address" "en-grafana" {
  name = var.en_grafana_ip_name
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

# DNS
data "cloudflare_zone" "dns_zone" {
  name = var.cloudflare_dns_zone
}

resource "cloudflare_record" "explorer" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.explorer_sepolia_dns
  content = data.google_compute_global_address.explorer-app.address
  type    = "A"
  proxied = true

  depends_on = [
    google_compute_global_address.explorer-app
  ]
}

resource "cloudflare_record" "explorer-api" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.explorer_api_sepolia_dns
  content = data.google_compute_global_address.explorer-api.address
  type    = "A"
  proxied = true

  depends_on = [
    google_compute_global_address.explorer-api
  ]
}

resource "cloudflare_record" "portal" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.portal_sepolia_dns
  content = data.google_compute_global_address.portal.address
  type    = "A"
  proxied = true

  depends_on = [
    google_compute_global_address.portal
  ]
}

resource "cloudflare_record" "rpc" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.rpc_sepolia_dns
  content = data.google_compute_global_address.server.address
  type    = "A"
  proxied = true

  depends_on = [
    google_compute_global_address.server
  ]
}

resource "cloudflare_record" "grafana" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.grafana_sepolia_dns
  content = data.google_compute_global_address.grafana.address
  type    = "A"
  proxied = true

  depends_on = [
    google_compute_global_address.grafana
  ]
}

resource "cloudflare_record" "en01-rpc" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.external_node_sepolia_dns
  content = data.google_compute_global_address.external-node.address
  type    = "A"
  proxied = true

  depends_on = [
    google_compute_global_address.external-node
  ]
}

resource "cloudflare_record" "en01-grafana" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.external_node_grafana_sepolia_dns
  content = data.google_compute_global_address.en-grafana.address
  type    = "A"
  proxied = true

  depends_on = [
    google_compute_global_address.en-grafana
  ]
}
