terraform {
  required_version = ">= 0.14.0"

  required_providers {
    google = {
      version = "~> 3.55.0"
      source = "hashicorp/google"
    }

    kubernetes = {
      version = "~> 1.13.3"
      source = "hashicorp/kubernetes"
    }
  }
}

provider "google" {
  credentials = base64decode(var.svc_account_key)

  project = var.project_id
  region  = var.region
}
