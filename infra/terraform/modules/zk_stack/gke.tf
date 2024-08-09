module "zk-stack-stack-gke-cluster" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version                    = "31.1.0"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = ["${var.region}-a", "${var.region}-b", "${var.region}-c"]
  release_channel            = "STABLE"

  # Network config
  network           = var.cluster_name
  subnetwork        = var.cluster_name
  ip_range_pods     = data.google_compute_subnetwork.gke-cluster-subnetwork.secondary_ip_range[0].range_name
  ip_range_services = data.google_compute_subnetwork.gke-cluster-subnetwork.secondary_ip_range[1].range_name

  # Addons
  http_load_balancing         = true
  horizontal_pod_autoscaling  = true
  network_policy              = false

  # Secrets encryption config
  database_encryption = [
    {
      "key_name": google_kms_crypto_key.k8s-secrets-encryption-key.id,
      "state": "ENCRYPTED"
    }
  ]

  node_pools = [
    {
      name                        = "cpu-node-pool"
      machine_type                = var.cpu_machine_type
      node_locations              = var.cpu_nodes_locations
      node_count                  = var.cpu_nodes_per_zone
      min_count                   = var.cpu_nodes_per_zone
      max_count                   = var.cpu_nodes_per_zone
      local_ssd_count             = 0
      spot                        = false
      disk_size_gb                = var.cpu_nodes_disk_size_gb
      disk_type                   = "pd-ssd"
      image_type                  = "COS_CONTAINERD"
      enable_gcfs                 = false
      enable_gvnic                = false
      logging_variant             = "DEFAULT"
      auto_repair                 = true
      auto_upgrade                = true
      preemptible                 = false
      initial_node_count          = var.cpu_nodes_per_zone
      accelerator_count           = 0
    },
    {
      name                        = "gpu-node-pool"
      machine_type                = var.gpu_machine_type
      node_locations              = var.gpu_nodes_locations
      node_count                  = var.gpu_nodes_per_zone
      min_count                   = var.gpu_nodes_per_zone
      max_count                   = var.gpu_nodes_per_zone
      local_ssd_count             = 0
      spot                        = true
      disk_size_gb                = var.gpu_nodes_disk_size_gb
      disk_type                   = "pd-ssd"
      image_type                  = "COS_CONTAINERD"
      enable_gcfs                 = false
      enable_gvnic                = false
      logging_variant             = "DEFAULT"
      auto_repair                 = true
      auto_upgrade                = true
      preemptible                 = false
      initial_node_count          = var.gpu_nodes_per_zone

      # GPU config
      accelerator_count          = var.gpus_per_node
      accelerator_type           = var.gpu_type
      # GPU drivers automatic installation config
      gpu_driver_version         = "DEFAULT"
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    cpu-node-pool = {
      cpu-node-pool = true
    }

    gpu-node-pool = {
      gpu-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    cpu-node-pool = {
      cpu-node-pool = true
    }

    gpu-node-pool = {
      gpu-node-pool = true
    }
  }

  node_pools_taints = {
    all = []

    cpu-node-pool = [
      {
        key    = "cpu-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
    gpu-node-pool = [
      {
        key    = "gpu-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
      {
        key    = "nvidia.com/gpu"
        value  = "present"
        effect = "NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    cpu-node-pool = [
      "cpu-node-pool",
    ]

    gpu-node-pool = [
      "gpu-node-pool",
    ]
  }
}
