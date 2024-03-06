
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.19.0"
    }
  }
}

provider "google" {
  project = "YOUR-PROJECT-HERE"
  region  = "us-west1"
}
