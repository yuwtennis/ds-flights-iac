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
  required_version = "~> 1.11.0"
}

provider "google" {
  region = local.region
}

provider "template" {}