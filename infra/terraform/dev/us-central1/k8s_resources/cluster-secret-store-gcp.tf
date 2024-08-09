resource "kubernetes_manifest" "cluster-secret-store-gcp" {
  manifest = yamldecode(file("${path.module}/k8s/cluster-secret-store-gcp.yaml"))
}
