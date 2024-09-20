module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version                    = "31.1.0"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = ["${var.region}-a", "${var.region}-b", "${var.region}-c"]
  release_channel            = "STABLE"
  kubernetes_version         = "1.30.2-gke.1587003"

  # Network config
  network           = "default"
  subnetwork        = "default"
  ip_range_pods     = "${var.region}-01-gke-01-pods"
  ip_range_services = "${var.region}-01-gke-01-services"

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
      disk_size_gb                = 100
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
    #{
    #  name                        = "gpu-node-pool-x2"
    #  machine_type                = var.gpu_machine_type
    #  node_locations              = var.gpu_nodes_locations
    #  node_count                  = var.gpu_nodes_per_zone
    #  min_count                   = var.gpu_nodes_per_zone
    #  max_count                   = var.gpu_nodes_per_zone
    #  local_ssd_count             = 0
    #  spot                        = false
    #  disk_size_gb                = 100
    #  disk_type                   = "pd-ssd"
    #  image_type                  = "COS_CONTAINERD"
    #  enable_gcfs                 = false
    #  enable_gvnic                = false
    #  logging_variant             = "DEFAULT"
    #  auto_repair                 = true
    #  auto_upgrade                = true
    #  preemptible                 = false
    #  initial_node_count          = var.gpu_nodes_per_zone

    #  # GPU config
    #  accelerator_count          = 2
    #  accelerator_type           = "nvidia-l4"
    #  # GPU drivers automatic installation config
    #  gpu_driver_version         = "DEFAULT"
    #},
    {
      name                        = "gpu-node-pool-x4-gpuz"
      machine_type                = "g2-standard-48"
      node_locations              = "us-central1-c"
      node_count                  = var.gpu_nodes_per_zone
      min_count                   = var.gpu_nodes_per_zone
      max_count                   = var.gpu_nodes_per_zone
      local_ssd_count             = 0
      spot                        = false
      disk_size_gb                = 100
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
      accelerator_count          = 4
      accelerator_type           = "nvidia-l4"
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

    gpu-node-pool-x4-gpuz = {
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

    gpu-node-pool-x4-gpuz = {
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

    gpu-node-pool-x4-gpuz = [
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

    gpu-node-pool-x4-gpuz = [
      "gpu-node-pool",
    ]
  }
}
