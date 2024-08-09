resource "google_sql_database_instance" "zksync_dev_prover_01" {
  name             = "zksync-dev-prover-01"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    tier              = "db-custom-4-15360"
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    disk_type         = "PD_SSD"
    disk_size         = 100
    disk_autoresize   = true
    ip_configuration {
      ipv4_enabled = true

      authorized_networks {
        name  = "everything"
        value = "0.0.0.0/0"
      }
    }
    backup_configuration {
      enabled = false
    }
  }
}

resource "google_sql_user" "lambda_prover" {
  name     = "lambda"
  instance = google_sql_database_instance.zksync_dev_prover_01.name
  password = var.sql_password
}
