resource "google_kms_key_ring" "k8s-secrets-encryption-keyring" {
  name     = "${var.cluster_name}-keyring"
  location = var.region
}

resource "google_kms_crypto_key" "k8s-secrets-encryption-key" {
  name            = "${var.cluster_name}-key"
  key_ring        = google_kms_key_ring.k8s-secrets-encryption-keyring.id
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = var.encryption_key_prevent_destroy
  }
}
