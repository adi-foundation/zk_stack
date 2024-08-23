# Cloudflare DNS
data "cloudflare_zone" "lambdaclass" {
  name = var.cloudflare_dns_zone
}

resource "cloudflare_record" "k8s-explorer-sepolia" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.explorer_sepolia_dns
  content = data.google_compute_global_address.explorer-app.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "k8s-explorer-api-sepolia" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.explorer_api_sepolia_dns
  content = data.google_compute_global_address.explorer-api.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "k8s-portal-sepolia" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.portal_sepolia_dns
  content = data.google_compute_global_address.portal.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "k8s-rpc-sepolia" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.rpc_sepolia_dns
  content = data.google_compute_global_address.server.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "k8s-grafana-sepolia" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.grafana_sepolia_dns
  content = data.google_compute_global_address.grafana.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "k8s-en01-rpc-sepolia" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.external_node_sepolia_dns
  content = data.google_compute_global_address.external-node.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "k8s-en01-grafana-sepolia" {
  zone_id = data.cloudflare_zone.lambdaclass.id
  name    = var.external_node_grafana_sepolia_dns
  content = data.google_compute_global_address.en-grafana.address
  type    = "A"
  proxied = true
}

# Cloudflare Rate Limit for RPC
resource "cloudflare_ruleset" "rpc-rate-limit" {
  zone_id     = data.cloudflare_zone.lambdaclass.id
  name        = "Rate limiting for the RPC"
  kind        = "zone"
  phase       = "http_ratelimit"

  rules {
    action = "block"
    ratelimit {
      characteristics = ["cf.colo.id", "ip.src"]
      period = 60
      requests_per_period = 30
      mitigation_timeout = 60
    }
    expression = "(http.host eq \"${var.rpc_sepolia_dns}.${var.cloudflare_dns_zone}\")"
    enabled = true
  }
}
