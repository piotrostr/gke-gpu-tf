terraform {
  required_providers {
    google = {
      version = "4.32.0"
      source  = "hashicorp/google"
    }
    kubernetes = {
      version = "2.12.1"
      source  = "hashicorp/kubernetes"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
