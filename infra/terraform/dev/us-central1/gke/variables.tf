variable "region" {
  type    = string
  default = "us-central1"
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "cpu_machine_type" {
  type    = string
  default = "c3-highmem-22"
}

variable "gpu_machine_type" {
  type    = string
  default = "g2-standard-24"
}

variable "cpu_nodes_locations" {
  type    = string
}

variable "cpu_nodes_per_zone" {
  type    = number
  default = 1
}

variable "gpu_nodes_locations" {
  type    = string
  default = "us-central1-c"
}

variable "gpu_nodes_per_zone" {
  type    = number
  default = 1
}

variable "cpu_nodes_disk_size" {
  type    = number
  default = 100
}

variable "gpu_nodes_disk_size" {
  type    = number
  default = 100
}

variable "aws_dns_zone" {
  type = string
}

variable "explorer_sepolia_dns" {
  type = string
}

variable "explorer_api_sepolia_dns" {
  type = string
}

variable "portal_sepolia_dns" {
  type = string
}

variable "rpc_sepolia_dns" {
  type = string
}

variable "grafana_sepolia_dns" {
  type = string
}

variable "external_node_sepolia_dns" {
  type = string
}

variable "external_node_grafana_sepolia_dns" {
  type = string
}

variable "explorer_app_public_ip_name" {
  type = string
}

variable "explorer_api_public_ip_name" {
  type = string
}

variable "portal_public_ip_name" {
  type = string
}

variable "server_public_ip_name" {
  type = string
}

variable "grafana_public_ip_name" {
  type = string
}

variable "external_node_public_ip_name" {
  type = string
}

variable "external_node_grafana_public_ip_name" {
  type = string
}
