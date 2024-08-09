# cert-manager (https://cert-manager.io/)
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

resource "kubectl_manifest" "http01-issuer" {
  yaml_body = file("${path.module}/k8s/http01-issuer.yaml")

  depends_on = [
    helm_release.cert-manager
  ]
}

# external-secrets (https://external-secrets.io/)
locals {
  external_secrets_namespace = "external-secrets"
  external_secrets_service_account_principal = "principal://iam.googleapis.com/projects/${data.google_project.zksync.number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/${local.external_secrets_namespace}/sa/external-secrets"
}

resource "helm_release" "external-secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "v0.9.20"
  namespace        = local.external_secrets_namespace
  create_namespace = true
}

resource "google_project_iam_binding" "external-secrets-secret-accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"

  members = [
    local.external_secrets_service_account_principal,
  ]

  depends_on = [
    helm_release.external-secrets
  ]
}

resource "google_project_iam_binding" "external-secrets-sa-token-creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    local.external_secrets_service_account_principal,
  ]

  depends_on = [
    helm_release.external-secrets
  ]
}

resource "kubectl_manifest" "cluster-secret-store-gcp" {
  yaml_body = file("${path.module}/k8s/cluster-secret-store-gcp.yaml")

  depends_on = [
    google_project_iam_binding.external-secrets-secret-accessor,
    google_project_iam_binding.external-secrets-sa-token-creator
  ]
}
