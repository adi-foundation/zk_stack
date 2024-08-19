# VPC Peering between Cloud SQL and VPC
resource "google_compute_global_address" "peering_default_ip_range" {
  name          = "peering-default-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = google_compute_network.gke-cluster-network.id

  depends_on = [
    google_compute_subnetwork.gke-cluster-subnetwork
  ]
}

resource "google_service_networking_connection" "databases" {
  network                 = google_compute_network.gke-cluster-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.peering_default_ip_range.name
  ]
}

resource "google_compute_network_peering_routes_config" "dbs_peering_routes" {
  peering              = google_service_networking_connection.databases.peering
  network              = google_compute_network.gke-cluster-network.name
  import_custom_routes = true
  export_custom_routes = true
}

# Central DB
resource "google_sql_database_instance" "general" {
  name             = var.cluster_name
  database_version = "POSTGRES_14"
  region           = var.region

  deletion_protection = false

  settings {
    tier              = var.db_size # "db-custom-4-15360"
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    disk_type         = "PD_SSD"
    disk_size         = var.db_disk_size_gb
    disk_autoresize   = true
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.gke-cluster-network.id
    }
    backup_configuration {
      enabled = false
    }
  }

  depends_on = [
    google_service_networking_connection.databases
  ]
}

resource "google_sql_user" "general" {
  name     = var.sql_user
  instance = google_sql_database_instance.general.name
  password = var.sql_password
}

# Prover DB
resource "google_sql_database_instance" "prover" {
  name             = "${var.cluster_name}-prover"
  database_version = "POSTGRES_14"
  region           = var.region

  deletion_protection = false

  settings {
    tier              = var.prover_db_size
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    disk_type         = "PD_SSD"
    disk_size         = var.prover_db_disk_size_gb
    disk_autoresize   = true
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.gke-cluster-network.id
    }
    backup_configuration {
      enabled = false
    }
  }

  depends_on = [
    google_service_networking_connection.databases
  ]
}

resource "google_sql_user" "prover" {
  name     = var.prover_sql_user
  instance = google_sql_database_instance.prover.name
  password = var.prover_sql_password
}
