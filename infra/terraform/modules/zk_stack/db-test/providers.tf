terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.35.0"
    }
  }

  backend "gcs" {
    bucket  = "zksync_terraform_state"
    prefix  = "dev/db_test"
  }
}

provider "google" {
  project = "zksync-413615"
}
