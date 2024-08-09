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
