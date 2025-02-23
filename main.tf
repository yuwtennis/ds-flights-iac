terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.19.0"
    }
  }
  required_version = "~> 1.10.5"
}

provider "google" {
  project = var.project
  region  = local.region
}
