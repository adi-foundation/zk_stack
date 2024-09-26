<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.58.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.35.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.14.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.0 |
| <a name="provider_google"></a> [google](#provider\_google) | 5.35.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.14.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_zk-stack-gke-cluster"></a> [zk-stack-gke-cluster](#module\_zk-stack-gke-cluster) | terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster | 31.1.0 |

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.en01-grafana](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.en01-rpc](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.explorer](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.explorer-api](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.grafana](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.portal](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.rpc](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_ruleset.rpc-rate-limit](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset) | resource |
| [google_compute_global_address.en-grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.explorer-api](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.explorer-app](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.external-node](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.peering_default_ip_range](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.portal](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_global_address.server](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_global_address) | resource |
| [google_compute_network.gke-cluster-network](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_network) | resource |
| [google_compute_network_peering_routes_config.dbs_peering_routes](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_network_peering_routes_config) | resource |
| [google_compute_subnetwork.gke-cluster-subnetwork](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/compute_subnetwork) | resource |
| [google_kms_crypto_key.k8s-secrets-encryption-key](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/kms_crypto_key) | resource |
| [google_kms_key_ring.k8s-secrets-encryption-keyring](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/kms_key_ring) | resource |
| [google_project_iam_binding.external-secrets-sa-token-creator](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.external-secrets-secret-accessor](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/project_iam_binding) | resource |
| [google_service_networking_connection.databases](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/service_networking_connection) | resource |
| [google_sql_database_instance.general](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_database_instance) | resource |
| [google_sql_database_instance.prover](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_database_instance) | resource |
| [google_sql_user.general](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_user) | resource |
| [google_sql_user.prover](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/resources/sql_user) | resource |
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
| [kubectl_manifest.cluster-secret-store-gcp](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.http01-issuer](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubernetes_service_account.buckets-rw](https://registry.terraform.io/providers/hashicorp/kubernetes/2.31.0/docs/resources/service_account) | resource |
| [cloudflare_zone.dns_zone](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/client_config) | data source |
| [google_compute_global_address.en-grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.explorer-api](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.explorer-app](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.external-node](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.grafana](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.portal](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_global_address.server](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_global_address) | data source |
| [google_compute_subnetwork.gke-cluster-subnetwork](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/compute_subnetwork) | data source |
| [google_project.zksync](https://registry.terraform.io/providers/hashicorp/google/5.35.0/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API token for the zone you will use for DNS records: https://developers.cloudflare.com/fundamentals/api/get-started/create-token/ | `string` | n/a | yes |
| <a name="input_cloudflare_dns_zone"></a> [cloudflare\_dns\_zone](#input\_cloudflare\_dns\_zone) | Cloudflare DNS zone where to create DNS records. For example: `example.com` | `string` | n/a | yes |
| <a name="input_cluster_locations"></a> [cluster\_locations](#input\_cluster\_locations) | List of GCP zones (inside the region you specified) where the cluster will be | `list` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name to give to the GKE cluster | `string` | n/a | yes |
| <a name="input_cpu_machine_type"></a> [cpu\_machine\_type](#input\_cpu\_machine\_type) | GCP machine type for the CPU nodes of the GKE cluster | `string` | `"c3-highmem-22"` | no |
| <a name="input_cpu_nodes_disk_size_gb"></a> [cpu\_nodes\_disk\_size\_gb](#input\_cpu\_nodes\_disk\_size\_gb) | Size in GiB for the CPU nodes' disks | `number` | `100` | no |
| <a name="input_cpu_nodes_locations"></a> [cpu\_nodes\_locations](#input\_cpu\_nodes\_locations) | Comma-separated zones for the CPU nodes inside the region you chose. For instance: "us-central1-a,us-central1-b" | `string` | `"us-central1-a"` | no |
| <a name="input_cpu_nodes_per_zone"></a> [cpu\_nodes\_per\_zone](#input\_cpu\_nodes\_per\_zone) | Number of CPU nodes to deploy per zone (related to cpu\_nodes\_locations) | `number` | `1` | no |
| <a name="input_db_disk_size_gb"></a> [db\_disk\_size\_gb](#input\_db\_disk\_size\_gb) | Cloud SQL General DB disk size in GiB | `string` | `"100"` | no |
| <a name="input_db_size"></a> [db\_size](#input\_db\_size) | Cloud SQL General DB size/type | `string` | `"db-custom-4-15360"` | no |
| <a name="input_en_grafana_ip_name"></a> [en\_grafana\_ip\_name](#input\_en\_grafana\_ip\_name) | Name for the GCP Global IP for the external node's grafana | `string` | `"en01-grafana-ip"` | no |
| <a name="input_encryption_key_prevent_destroy"></a> [encryption\_key\_prevent\_destroy](#input\_encryption\_key\_prevent\_destroy) | Whether to prevent destroying the GCP KMS decrpytion key for Kubernetes data | `bool` | `true` | no |
| <a name="input_explorer_api_ip_name"></a> [explorer\_api\_ip\_name](#input\_explorer\_api\_ip\_name) | Name for the GCP Global IP for the explorer api | `string` | `"explorer-api-ip"` | no |
| <a name="input_explorer_api_sepolia_dns"></a> [explorer\_api\_sepolia\_dns](#input\_explorer\_api\_sepolia\_dns) | DNS which will point to the explorer api, as a suffix to the main DNS zone. For example, "my-app" would render to `my-app.example.com` | `string` | n/a | yes |
| <a name="input_explorer_app_ip_name"></a> [explorer\_app\_ip\_name](#input\_explorer\_app\_ip\_name) | Name for the GCP Global IP for the explorer app | `string` | `"explorer-app-ip"` | no |
| <a name="input_explorer_sepolia_dns"></a> [explorer\_sepolia\_dns](#input\_explorer\_sepolia\_dns) | DNS which will point to the explorer app, as a suffix to the main DNS zone. For example, "my-app" would render to `my-app.example.com` | `string` | n/a | yes |
| <a name="input_external_node_grafana_sepolia_dns"></a> [external\_node\_grafana\_sepolia\_dns](#input\_external\_node\_grafana\_sepolia\_dns) | DNS which will point to the external node's grafana, as a suffix to the main DNS zone. For example, "my-app" would render to `my-app.example.com` | `string` | n/a | yes |
| <a name="input_external_node_ip_name"></a> [external\_node\_ip\_name](#input\_external\_node\_ip\_name) | Name for the GCP Global IP for the external node | `string` | `"external-node-ip"` | no |
| <a name="input_external_node_sepolia_dns"></a> [external\_node\_sepolia\_dns](#input\_external\_node\_sepolia\_dns) | DNS which will point to the external node, as a suffix to the main DNS zone. For example, "my-app" would render to `my-app.example.com` | `string` | n/a | yes |
| <a name="input_gpu_machine_type"></a> [gpu\_machine\_type](#input\_gpu\_machine\_type) | GCP machine type for the GPU nodes of the GKE cluster | `string` | `"g2-standard-24"` | no |
| <a name="input_gpu_nodes_disk_size_gb"></a> [gpu\_nodes\_disk\_size\_gb](#input\_gpu\_nodes\_disk\_size\_gb) | Size in GiB for the GPU nodes' disks | `number` | `100` | no |
| <a name="input_gpu_nodes_locations"></a> [gpu\_nodes\_locations](#input\_gpu\_nodes\_locations) | Comma-separated zones for the GPU nodes inside the region you chose. For instance: "us-central1-a,us-central1-b" | `string` | `"us-central1-c"` | no |
| <a name="input_gpu_nodes_per_zone"></a> [gpu\_nodes\_per\_zone](#input\_gpu\_nodes\_per\_zone) | Number of GPU nodes to deploy per zone (related to gpu\_nodes\_locations) | `number` | `1` | no |
| <a name="input_gpu_type"></a> [gpu\_type](#input\_gpu\_type) | Type of NVIDIA GPU to attach to the GPU nodes. Note: G2 instances only work with NVIDIA L4. For more information: https://cloud.google.com/compute/docs/accelerator-optimized-machines | `string` | `"nvidia-l4"` | no |
| <a name="input_gpus_per_node"></a> [gpus\_per\_node](#input\_gpus\_per\_node) | Number of NVIDIA GPUs to attach to each GPU node | `number` | `2` | no |
| <a name="input_grafana_ip_name"></a> [grafana\_ip\_name](#input\_grafana\_ip\_name) | Name for the GCP Global IP for grafana | `string` | `"grafana-ip"` | no |
| <a name="input_grafana_sepolia_dns"></a> [grafana\_sepolia\_dns](#input\_grafana\_sepolia\_dns) | DNS which will point to grafana, as a suffix to the main DNS zone. For example, "my-app" would render to `my-app.example.com` | `string` | n/a | yes |
| <a name="input_object_store_bucket_name"></a> [object\_store\_bucket\_name](#input\_object\_store\_bucket\_name) | GCS Bucket name for the object store bucket | `string` | `"object-store-dev"` | no |
| <a name="input_portal_ip_name"></a> [portal\_ip\_name](#input\_portal\_ip\_name) | Name for the GCP Global IP for the portal | `string` | `"portal-ip"` | no |
| <a name="input_portal_sepolia_dns"></a> [portal\_sepolia\_dns](#input\_portal\_sepolia\_dns) | DNS which will point to the portal, as a suffix to the main DNS zone. For example, "my-app" would render to `my-app.example.com` | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID of the GCP Project to deploy all the infrastructure | `string` | n/a | yes |
| <a name="input_prover_db_disk_size_gb"></a> [prover\_db\_disk\_size\_gb](#input\_prover\_db\_disk\_size\_gb) | Cloud SQL Prover DB disk size in GiB | `string` | `"100"` | no |
| <a name="input_prover_db_size"></a> [prover\_db\_size](#input\_prover\_db\_size) | Cloud SQL Prover DB size/type | `string` | `"db-custom-4-15360"` | no |
| <a name="input_prover_object_store_bucket_name"></a> [prover\_object\_store\_bucket\_name](#input\_prover\_object\_store\_bucket\_name) | GCS Bucket name for the prover object store bucket | `string` | `"prover-object-store-dev"` | no |
| <a name="input_prover_setup_data_bucket_name"></a> [prover\_setup\_data\_bucket\_name](#input\_prover\_setup\_data\_bucket\_name) | GCS Bucket name for the prover setup data bucket | `string` | `"prover-setup-data"` | no |
| <a name="input_prover_sql_password"></a> [prover\_sql\_password](#input\_prover\_sql\_password) | Cloud SQL Prover DB password | `string` | n/a | yes |
| <a name="input_prover_sql_user"></a> [prover\_sql\_user](#input\_prover\_sql\_user) | Cloud SQL Prover DB username | `string` | n/a | yes |
| <a name="input_public_object_store_bucket_name"></a> [public\_object\_store\_bucket\_name](#input\_public\_object\_store\_bucket\_name) | GCS Bucket name for the public object store bucket | `string` | `"public-object-store-dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region in which to deploy the cluster. Note: it needs to have GPU availability (G2 instances). More info: https://cloud.google.com/compute/docs/regions-zones#available | `string` | n/a | yes |
| <a name="input_rpc_sepolia_dns"></a> [rpc\_sepolia\_dns](#input\_rpc\_sepolia\_dns) | DNS which will point to the rpc (server), as a suffix to the main DNS zone. For example, "my-app" would render to `my-app.example.com` | `string` | n/a | yes |
| <a name="input_server_ip_name"></a> [server\_ip\_name](#input\_server\_ip\_name) | Name for the GCP Global IP for the server | `string` | `"server-ip"` | no |
| <a name="input_snapshots_object_store_bucket_name"></a> [snapshots\_object\_store\_bucket\_name](#input\_snapshots\_object\_store\_bucket\_name) | GCS Bucket name for the snapshots object store bucket | `string` | `"snapshots-object-store-dev"` | no |
| <a name="input_sql_password"></a> [sql\_password](#input\_sql\_password) | Cloud SQL General DB password | `string` | n/a | yes |
| <a name="input_sql_user"></a> [sql\_user](#input\_sql\_user) | Cloud SQL General DB username | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->