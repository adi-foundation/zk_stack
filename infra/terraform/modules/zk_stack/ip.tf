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

data "aws_route53_zone" "zk-stack-lambdaclass-com" {
  name         = "${var.aws_dns_zone}."
}

resource "aws_route53_record" "k8s-explorer-sepolia" {
  zone_id = data.aws_route53_zone.zk-stack-lambdaclass-com.id
  name    = "${var.explorer_sepolia_dns}.${data.aws_route53_zone.zk-stack-lambdaclass-com.name}"
  type    = "A"
  ttl     = "300"
  records = [data.google_compute_global_address.explorer-app.address]

  depends_on = [
    google_compute_global_address.explorer-app
  ]
}

resource "aws_route53_record" "k8s-explorer-api-sepolia" {
  zone_id = data.aws_route53_zone.zk-stack-lambdaclass-com.id
  name    = "${var.explorer_api_sepolia_dns}.${data.aws_route53_zone.zk-stack-lambdaclass-com.name}"
  type    = "A"
  ttl     = "300"
  records = [data.google_compute_global_address.explorer-api.address]

  depends_on = [
    google_compute_global_address.explorer-api
  ]
}

resource "aws_route53_record" "k8s-portal-sepolia" {
  zone_id = data.aws_route53_zone.zk-stack-lambdaclass-com.id
  name    = "${var.portal_sepolia_dns}.${data.aws_route53_zone.zk-stack-lambdaclass-com.name}"
  type    = "A"
  ttl     = "300"
  records = [data.google_compute_global_address.portal.address]

  depends_on = [
    google_compute_global_address.portal
  ]
}

resource "aws_route53_record" "k8s-rpc-sepolia" {
  zone_id = data.aws_route53_zone.zk-stack-lambdaclass-com.id
  name    = "${var.rpc_sepolia_dns}.${data.aws_route53_zone.zk-stack-lambdaclass-com.name}"
  type    = "A"
  ttl     = "300"
  records = [data.google_compute_global_address.server.address]

  depends_on = [
    google_compute_global_address.server
  ]
}

resource "aws_route53_record" "k8s-grafana-sepolia" {
  zone_id = data.aws_route53_zone.zk-stack-lambdaclass-com.id
  name    = "${var.grafana_sepolia_dns}.${data.aws_route53_zone.zk-stack-lambdaclass-com.name}"
  type    = "A"
  ttl     = "300"
  records = [data.google_compute_global_address.grafana.address]

  depends_on = [
    google_compute_global_address.grafana
  ]
}

resource "aws_route53_record" "k8s-en01-rpc-sepolia" {
  zone_id = data.aws_route53_zone.zk-stack-lambdaclass-com.id
  name    = "${var.external_node_sepolia_dns}.${data.aws_route53_zone.zk-stack-lambdaclass-com.name}"
  type    = "A"
  ttl     = "300"
  records = [data.google_compute_global_address.external-node.address]

  depends_on = [
    google_compute_global_address.external-node
  ]
}


resource "aws_route53_record" "k8s-en01-grafana-sepolia" {
  zone_id = data.aws_route53_zone.zk-stack-lambdaclass-com.id
  name    = "${var.external_node_grafana_sepolia_dns}.${data.aws_route53_zone.zk-stack-lambdaclass-com.name}"
  type    = "A"
  ttl     = "300"
  records = [data.google_compute_global_address.en-grafana.address]

  depends_on = [
    google_compute_global_address.en-grafana
  ]
}
