terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  required_version = "~> 1.12.0"

  backend "gcs" {
    bucket = "dsongcp-452504-tf-state"
  }
}

provider "google" {
  region = local.region
}

provider "template" {}