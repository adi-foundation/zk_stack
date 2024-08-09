<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.58.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.35.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |
| <a name="provider_google"></a> [google](#provider\_google) | 5.35.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster | 31.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.k8s-en01-grafana-sepolia](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route53_record) | resource |
| [aws_route53_record.k8s-en01-rpc-sepolia](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route53_record) | resource |
| [aws_route53_record.k8s-explorer-api-sepolia](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route53_record) | resource |
| [aws_route53_record.k8s-explorer-sepolia](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route53_record) | resource |
| [aws_route53_record.k8s-grafana-sepolia](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route53_record) | resource |
| [aws_route53_record.k8s-portal-sepolia](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route53_record) | resource |
| [aws_route53_record.k8s-rpc-sepolia](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/route53_record) | resource |
| [google_compute_global_address.en-grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.explorer-api](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.explorer-app](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.external-node](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.portal](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.server](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_kms_crypto_key.k8s-secrets-encryption-key](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/kms_crypto_key) | resource |
| [google_kms_key_ring.k8s-secrets-encryption-keyring](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/kms_key_ring) | resource |
| [google_project_iam_binding.external-secrets-sa-token-creator](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.external-secrets-secret-accessor](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/project_iam_binding) | resource |
| [google_storage_bucket.object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.prover-object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.prover-setup-data](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.public-object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.snapshots-object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_binding.object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket_iam_binding) | resource |
| [google_storage_bucket_iam_binding.prover-object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket_iam_binding) | resource |
| [google_storage_bucket_iam_binding.prover-setup-data](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket_iam_binding) | resource |
| [google_storage_bucket_iam_binding.public-object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket_iam_binding) | resource |
| [google_storage_bucket_iam_binding.snapshots-object-store-dev](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket_iam_binding) | resource |
| [google_storage_bucket_iam_member.public-object-store-dev-public-access](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.snapshots-object-store-dev-public-access](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/storage_bucket_iam_member) | resource |
| [helm_release.cert-manager](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [helm_release.external-secrets](https://registry.terraform.io/providers/hashicorp/helm/2.14.0/docs/resources/release) | resource |
| [kubernetes_manifest.http01-issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/manifest) | resource |
| [kubernetes_service_account.buckets-rw](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/service_account) | resource |
| [aws_route53_zone.zk-stack-lambdaclass-com](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/route53_zone) | data source |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/client_config) | data source |
| [google_compute_global_address.en-grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.explorer-api](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.explorer-app](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.external-node](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.portal](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.server](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_project.zksync](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_dns_zone"></a> [aws\_dns\_zone](#input\_aws\_dns\_zone) | n/a | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_cpu_machine_type"></a> [cpu\_machine\_type](#input\_cpu\_machine\_type) | n/a | `string` | `"c3-highmem-22"` | no |
| <a name="input_cpu_nodes_disk_size"></a> [cpu\_nodes\_disk\_size](#input\_cpu\_nodes\_disk\_size) | n/a | `number` | `100` | no |
| <a name="input_cpu_nodes_locations"></a> [cpu\_nodes\_locations](#input\_cpu\_nodes\_locations) | n/a | `string` | n/a | yes |
| <a name="input_cpu_nodes_per_zone"></a> [cpu\_nodes\_per\_zone](#input\_cpu\_nodes\_per\_zone) | n/a | `number` | `1` | no |
| <a name="input_explorer_api_public_ip_name"></a> [explorer\_api\_public\_ip\_name](#input\_explorer\_api\_public\_ip\_name) | n/a | `string` | n/a | yes |
| <a name="input_explorer_api_sepolia_dns"></a> [explorer\_api\_sepolia\_dns](#input\_explorer\_api\_sepolia\_dns) | n/a | `string` | n/a | yes |
| <a name="input_explorer_app_public_ip_name"></a> [explorer\_app\_public\_ip\_name](#input\_explorer\_app\_public\_ip\_name) | n/a | `string` | n/a | yes |
| <a name="input_explorer_sepolia_dns"></a> [explorer\_sepolia\_dns](#input\_explorer\_sepolia\_dns) | n/a | `string` | n/a | yes |
| <a name="input_external_node_grafana_public_ip_name"></a> [external\_node\_grafana\_public\_ip\_name](#input\_external\_node\_grafana\_public\_ip\_name) | n/a | `string` | n/a | yes |
| <a name="input_external_node_grafana_sepolia_dns"></a> [external\_node\_grafana\_sepolia\_dns](#input\_external\_node\_grafana\_sepolia\_dns) | n/a | `string` | n/a | yes |
| <a name="input_external_node_public_ip_name"></a> [external\_node\_public\_ip\_name](#input\_external\_node\_public\_ip\_name) | n/a | `string` | n/a | yes |
| <a name="input_external_node_sepolia_dns"></a> [external\_node\_sepolia\_dns](#input\_external\_node\_sepolia\_dns) | n/a | `string` | n/a | yes |
| <a name="input_gpu_machine_type"></a> [gpu\_machine\_type](#input\_gpu\_machine\_type) | n/a | `string` | `"g2-standard-24"` | no |
| <a name="input_gpu_nodes_disk_size"></a> [gpu\_nodes\_disk\_size](#input\_gpu\_nodes\_disk\_size) | n/a | `number` | `100` | no |
| <a name="input_gpu_nodes_locations"></a> [gpu\_nodes\_locations](#input\_gpu\_nodes\_locations) | n/a | `string` | `"us-central1-c"` | no |
| <a name="input_gpu_nodes_per_zone"></a> [gpu\_nodes\_per\_zone](#input\_gpu\_nodes\_per\_zone) | n/a | `number` | `1` | no |
| <a name="input_grafana_public_ip_name"></a> [grafana\_public\_ip\_name](#input\_grafana\_public\_ip\_name) | n/a | `string` | n/a | yes |
| <a name="input_grafana_sepolia_dns"></a> [grafana\_sepolia\_dns](#input\_grafana\_sepolia\_dns) | n/a | `string` | n/a | yes |
| <a name="input_portal_public_ip_name"></a> [portal\_public\_ip\_name](#input\_portal\_public\_ip\_name) | n/a | `string` | n/a | yes |
| <a name="input_portal_sepolia_dns"></a> [portal\_sepolia\_dns](#input\_portal\_sepolia\_dns) | n/a | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1"` | no |
| <a name="input_rpc_sepolia_dns"></a> [rpc\_sepolia\_dns](#input\_rpc\_sepolia\_dns) | n/a | `string` | n/a | yes |
| <a name="input_server_public_ip_name"></a> [server\_public\_ip\_name](#input\_server\_public\_ip\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_buckets-urls"></a> [buckets-urls](#output\_buckets-urls) | n/a |
| <a name="output_command-for-k8s-credentials"></a> [command-for-k8s-credentials](#output\_command-for-k8s-credentials) | n/a |
| <a name="output_explorer-app-dns"></a> [explorer-app-dns](#output\_explorer-app-dns) | n/a |
<!-- END_TF_DOCS -->