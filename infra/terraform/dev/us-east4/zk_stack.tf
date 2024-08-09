module "zk_stack" {
  source = "git::https://github.com/lambdaclass/zk_stack//infra/terraform/modules/zk_stack"

  region       = "us-east4"
  cluster_name = "zksync-dev-02"
  project_id   = "zksync-413615"

  # Nodes configs
  cpu_nodes_locations = "us-central1-a"
  gpu_nodes_locations = "us-central1-c"

  # DNS configuration
  aws_dns_zone                       = "zk-stack.lambdaclass.com"
  explorer_sepolia_dns               = "kube.explorer.sepolia"
  explorer_api_sepolia_dns           = "kube.explorer.api.sepolia"
  portal_sepolia_dns                 = "kube.portal.sepolia"
  rpc_sepolia_dns                    = "kube.rpc.sepolia"
  grafana_sepolia_dns                = "kube.grafana.sepolia"
  external_node_sepolia_dns          = "kube.en01.rpc.sepolia"
  external_node_grafana_sepolia_dns  = "kube.en01.grafana.sepolia"

  # IP configuration
  explorer_app_ip_name  = "explorer-app-ip-2"
  explorer_api_ip_name  = "explorer-api-ip-2"
  portal_ip_name        = "portal-ip-2"
  server_ip_name        = "server-ip-2"
  grafana_ip_name       = "grafana-ip-2"
  external_node_ip_name = "external-node-ip-2"
  en_grafana_ip_name    = "en01-grafana-ip-2"

  # Storage Buckets configuration
  object_store_bucket_name           = "object-store-dev-2"
  public_object_store_bucket_name    = "public-object-store-dev-2"
  prover_object_store_bucket_name    = "prover-object-store-dev-2"
  snapshots_object_store_bucket_name = "snapshots-object-store-dev-2"
  prover_setup_data_bucket_name      = "prover-setup-data-2"
}
