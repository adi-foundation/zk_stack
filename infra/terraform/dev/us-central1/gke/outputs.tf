output "explorer-app-dns" {
  value = aws_route53_record.k8s-explorer-sepolia.name
}

output "command-for-k8s-credentials" {
  value = "gcloud container clusters get-credentials ${module.gke.name} --region ${var.region} --project zksync-413615"
}

output "buckets-urls" {
  value = [
    google_storage_bucket.object-store-dev.url,
    google_storage_bucket.public-object-store-dev.url,
    google_storage_bucket.prover-object-store-dev.url,
    google_storage_bucket.snapshots-object-store-dev.url,
    google_storage_bucket.prover-setup-data.url,
  ]
}
