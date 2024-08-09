terraform {
  required_version = ">= 1.9.0"

  backend "gcs" {
    bucket  = "zksync_terraform_state"
    prefix  = "dev/module_tests/eks"
  }
}

provider "google" {
  project = "zksync-413615"
}
