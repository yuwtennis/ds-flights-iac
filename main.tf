terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  required_version = "~> 1.10.5"
}

provider "google" {
  region = local.region
}
