# PVCs
resource "kubernetes_manifest" "grafana-pvc" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/pvc/grafana.yaml"))
}

# Services
resource "kubernetes_manifest" "explorer-app-service" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/services/explorer-app.yaml"))
}

resource "kubernetes_manifest" "explorer-api-service" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/services/explorer-api.yaml"))
}

resource "kubernetes_manifest" "explorer-data-fetcher-service" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/services/explorer-data-fetcher.yaml"))
}

resource "kubernetes_manifest" "portal-service" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/services/portal.yaml"))
}

resource "kubernetes_manifest" "server-service" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/services/server.yaml"))
}

resource "kubectl_manifest" "grafana-service" {
  yaml_body = file("${path.module}/../../../../kubernetes/services/grafana.yaml")
}

resource "kubernetes_manifest" "en-service" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/services/external-node.yaml"))
}

resource "kubectl_manifest" "en-grafana-service" {
  yaml_body = file("${path.module}/../../../../kubernetes/services/en-grafana.yaml")
}

# Ingresses
resource "kubernetes_manifest" "explorer-app-ingress" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/ingress/explorer-app.yaml"))

  depends_on = [
    kubernetes_manifest.explorer-app-service
  ]
}

resource "kubernetes_manifest" "explorer-api-ingress" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/ingress/explorer-api.yaml"))

  depends_on = [
    kubernetes_manifest.explorer-api-service
  ]
}

resource "kubernetes_manifest" "portal-ingress" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/ingress/portal.yaml"))

  depends_on = [
    kubernetes_manifest.portal-service
  ]
}

resource "kubernetes_manifest" "server-ingress" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/ingress/server.yaml"))

  depends_on = [
    kubernetes_manifest.server-service
  ]
}

resource "kubernetes_manifest" "grafana-ingress" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/ingress/grafana.yaml"))

  depends_on = [
    kubectl_manifest.grafana-service
  ]
}

resource "kubernetes_manifest" "en-ingress" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/ingress/external-node.yaml"))

  depends_on = [
    kubernetes_manifest.en-service
  ]
}

resource "kubernetes_manifest" "en-grafana-ingress" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/ingress/en-grafana.yaml"))

  depends_on = [
    kubectl_manifest.en-grafana-service
  ]
}

# Deployments

resource "kubernetes_manifest" "contract-verifier-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/contract-verifier.yaml"))
}

resource "kubernetes_manifest" "explorer-app-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/explorer-app.yaml"))

  depends_on = [
    kubernetes_manifest.explorer-app-service
  ]
}

resource "kubernetes_manifest" "explorer-api-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/explorer-api.yaml"))

  depends_on = [
    kubernetes_manifest.explorer-api-service
  ]
}

resource "kubernetes_manifest" "explorer-data-fetcher-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/explorer-data-fetcher.yaml"))

  depends_on = [
    kubernetes_manifest.explorer-data-fetcher-service
  ]
}

resource "kubernetes_manifest" "explorer-worker-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/explorer-worker.yaml"))
}

resource "kubernetes_manifest" "portal-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/portal.yaml"))

  depends_on = [
    kubernetes_manifest.portal-service
  ]
}

resource "kubernetes_manifest" "server-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/server.yaml"))

  depends_on = [
    kubernetes_manifest.server-service
  ]
}

resource "kubernetes_manifest" "grafana-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/grafana.yaml"))

  depends_on = [
    kubectl_manifest.grafana-service,
    kubernetes_manifest.grafana-pvc
  ]
}

resource "kubernetes_manifest" "prover-gateway-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-gateway.yaml"))
}

resource "kubernetes_manifest" "basic-witness-generator-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-basic-witness-generator.yaml"))
}

resource "kubernetes_manifest" "leaf-witness-generator-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-leaf-witness-generator.yaml"))
}

resource "kubernetes_manifest" "node-witness-generator-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-node-witness-generator.yaml"))
}

resource "kubernetes_manifest" "recursion-tip-witness-generator-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-recursion-tip-witness-generator.yaml"))
}

resource "kubernetes_manifest" "scheduler-witness-generator-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-scheduler-witness-generator.yaml"))
}

resource "kubernetes_manifest" "prover-witness-vector-generator-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-witness-vector-generator.yaml"))
}

resource "kubernetes_manifest" "prover-prover-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-prover.yaml"))
}

resource "kubernetes_manifest" "prover-compressor-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/prover-compressor.yaml"))
}

resource "kubernetes_manifest" "en-deployment" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/deployments/external-node.yaml"))

  depends_on = [
    kubernetes_manifest.en-service
  ]
}

resource "kubectl_manifest" "en-grafana-deployment" {
  yaml_body = file("${path.module}/../../../../kubernetes/deployments/en-grafana.yaml")

  depends_on = [
    kubectl_manifest.en-grafana-service
  ]
}

# BackendConfigs

resource "kubernetes_manifest" "en-backend" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/backendconfigs/external-node.yaml"))

  depends_on = [
    kubernetes_manifest.en-service
  ]
}

resource "kubernetes_manifest" "server-backend" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/backendconfigs/server.yaml"))

  depends_on = [
    kubernetes_manifest.server-service
  ]
}

# CronJobs
resource "kubernetes_manifest" "snapshots-creator-cronjob" {
  manifest = yamldecode(file("${path.module}/../../../../kubernetes/cronjobs/snapshots-creator.yaml"))
}
