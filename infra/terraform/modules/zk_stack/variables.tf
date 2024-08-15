variable "region" {
  type        = string
  description = "GCP region in which to deploy the cluster. Note: it needs to have GPU availability (G2 instances). More info: https://cloud.google.com/compute/docs/regions-zones#available"
}

variable "cluster_name" {
  type        = string
  description = "Name to give to the GKE cluster"
}

variable "project_id" {
  type        = string
  description = "ID of the GCP Project to deploy all the infrastructure"
}

variable "cluster_locations" {
  type        = list
  description = "List of GCP zones (inside the region you specified) where the cluster will be"
}

variable "cpu_machine_type" {
  type        = string
  default     = "c3-highmem-22"
  description = "GCP machine type for the CPU nodes of the GKE cluster"
}

variable "cpu_nodes_locations" {
  type        = string
  default     = "us-central1-a"
  description = "Comma-separated zones for the CPU nodes inside the region you chose. For instance: \"us-central1-a,us-central1-b\""
}

variable "cpu_nodes_per_zone" {
  type        = number
  default     = 1
  description = "Number of CPU nodes to deploy per zone (related to cpu_nodes_locations)"
}

variable "cpu_nodes_disk_size_gb" {
  type        = number
  default     = 100
  description = "Size in GiB for the CPU nodes' disks"
}

variable "gpu_machine_type" {
  type        = string
  default     = "g2-standard-24"
  description = "GCP machine type for the GPU nodes of the GKE cluster"
}

variable "gpu_nodes_locations" {
  type        = string
  default     = "us-central1-c"
  description = "Comma-separated zones for the GPU nodes inside the region you chose. For instance: \"us-central1-a,us-central1-b\""
}

variable "gpu_nodes_per_zone" {
  type        = number
  default     = 1
  description = "Number of GPU nodes to deploy per zone (related to gpu_nodes_locations)"
}

variable "gpu_nodes_disk_size_gb" {
  type    = number
  default = 100
  description = "Size in GiB for the GPU nodes' disks"
}

variable "gpus_per_node" {
  type        = number
  default     = 2
  description = "Number of NVIDIA GPUs to attach to each GPU node"
}

variable "gpu_type" {
  type    = string
  default = "nvidia-l4"
  description = "Type of NVIDIA GPU to attach to the GPU nodes. Note: G2 instances only work with NVIDIA L4. For more information: https://cloud.google.com/compute/docs/accelerator-optimized-machines"
}

variable "explorer_app_ip_name" {
  type        = string
  default     = "explorer-app-ip"
  description = "Name for the GCP Global IP for the explorer app"
}

variable "explorer_api_ip_name" {
  type        = string
  default     = "explorer-api-ip"
  description = "Name for the GCP Global IP for the explorer api"
}

variable "portal_ip_name" {
  type        = string
  default     = "portal-ip"
  description = "Name for the GCP Global IP for the portal"
}

variable "server_ip_name" {
  type        = string
  default     = "server-ip"
  description = "Name for the GCP Global IP for the server"
}

variable "grafana_ip_name" {
  type        = string
  default     = "grafana-ip"
  description = "Name for the GCP Global IP for grafana"
}

variable "external_node_ip_name" {
  type        = string
  default     = "external-node-ip"
  description = "Name for the GCP Global IP for the external node"
}

variable "en_grafana_ip_name" {
  type        = string
  default     = "en01-grafana-ip"
  description = "Name for the GCP Global IP for the external node's grafana"
}

variable "aws_dns_zone" {
  type        = string
  description = "AWS Hosted Zone name to host all the DNSs, i.e.: \"example.com\""
}

variable "explorer_sepolia_dns" {
  type        = string
  description = "DNS which will point to the explorer app, as a suffix to the main DNS zone. For example, \"my-app\" would render to `my-app.example.com`"
}

variable "explorer_api_sepolia_dns" {
  type        = string
  description = "DNS which will point to the explorer api, as a suffix to the main DNS zone. For example, \"my-app\" would render to `my-app.example.com`"
}

variable "portal_sepolia_dns" {
  type        = string
  description = "DNS which will point to the portal, as a suffix to the main DNS zone. For example, \"my-app\" would render to `my-app.example.com`"
}

variable "rpc_sepolia_dns" {
  type        = string
  description = "DNS which will point to the rpc (server), as a suffix to the main DNS zone. For example, \"my-app\" would render to `my-app.example.com`"
}

variable "grafana_sepolia_dns" {
  type        = string
  description = "DNS which will point to grafana, as a suffix to the main DNS zone. For example, \"my-app\" would render to `my-app.example.com`"
}

variable "external_node_sepolia_dns" {
  type        = string
  description = "DNS which will point to the external node, as a suffix to the main DNS zone. For example, \"my-app\" would render to `my-app.example.com`"
}

variable "external_node_grafana_sepolia_dns" {
  type        = string
  description = "DNS which will point to the external node's grafana, as a suffix to the main DNS zone. For example, \"my-app\" would render to `my-app.example.com`"
}

variable "object_store_bucket_name" {
  type        = string
  default     = "object-store-dev"
  description = "GCS Bucket name for the object store bucket"
}

variable "public_object_store_bucket_name" {
  type        = string
  default     = "public-object-store-dev"
  description = "GCS Bucket name for the public object store bucket"
}

variable "prover_object_store_bucket_name" {
  type        = string
  default     = "prover-object-store-dev"
  description = "GCS Bucket name for the prover object store bucket"
}

variable "snapshots_object_store_bucket_name" {
  type        = string
  default     = "snapshots-object-store-dev"
  description = "GCS Bucket name for the snapshots object store bucket"
}

variable "prover_setup_data_bucket_name" {
  type        = string
  default     = "prover-setup-data"
  description = "GCS Bucket name for the prover setup data bucket"
}

variable "db_size" {
  type        = string
  default     = "db-custom-4-15360"
  description = "Cloud SQL General DB size/type"
}

variable "db_disk_size_gb" {
  type        = string
  default     = "100"
  description = "Cloud SQL General DB disk size in GiB"
}

variable "sql_user" {
  type        = string
  description = "Cloud SQL General DB username"
}

variable "sql_password" {
  type        = string
  description = "Cloud SQL General DB password"
}

variable "prover_db_size" {
  type        = string
  default     = "db-custom-4-15360"
  description = "Cloud SQL Prover DB size/type"
}

variable "prover_db_disk_size_gb" {
  type        = string
  default     = "100"
  description = "Cloud SQL Prover DB disk size in GiB"
}

variable "prover_sql_user" {
  type        = string
  description = "Cloud SQL Prover DB username"
}

variable "prover_sql_password" {
  type        = string
  description = "Cloud SQL Prover DB password"
}

variable "encryption_key_prevent_destroy" {
  type        = bool
  default     = true
  description = "Whether to prevent destroying the GCP KMS decrpytion key for Kubernetes data"
}
