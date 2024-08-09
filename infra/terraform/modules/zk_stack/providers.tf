terraform {
  required_version = ">= 1.9.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.35.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.58.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.31.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "kubernetes" {
  host                   = "https://${module.zk-stack-stack-gke-cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.zk-stack-stack-gke-cluster.ca_certificate)
}

provider "helm" {
  kubernetes {
     host                   = "https://${module.zk-stack-stack-gke-cluster.endpoint}"
     token                  = data.google_client_config.default.access_token
     cluster_ca_certificate = base64decode(module.zk-stack-stack-gke-cluster.ca_certificate)
  }
}

data "google_client_config" "default" {}
