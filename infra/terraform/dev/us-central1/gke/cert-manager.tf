resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.15.1"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }
}

resource "kubernetes_manifest" "http01-issuer" {
  manifest = yamldecode(file("${path.module}/k8s/http01-issuer.yaml"))

  depends_on = [
    helm_release.cert-manager
  ]
}
