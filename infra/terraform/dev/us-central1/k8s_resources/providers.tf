terraform {
  required_version = ">= 1.9.0"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.31.0"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }

  backend "gcs" {
    bucket  = "zksync_terraform_state"
    prefix  = "dev/k8s_resources"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_zksync-413615_us-central1_zksync-dev-01"
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "gke_zksync-413615_us-central1_zksync-dev-01"
}

provider "google" {
  project = "zksync-413615"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
