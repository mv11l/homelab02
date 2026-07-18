terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.78.0"
    }
  }
  required_version = ">= 0.13"
  backend "s3" {
    bucket                      = "homelab02-tofu-state"
    key                         = "state-file"
    region                      = "fr-par"
    endpoint                    = "https://s3.fr-par.scw.cloud"
    access_key                  = var.bucket_state_access_key
    secret_key                  = var.bucket_state_secret_key
    skip_credentials_validation = true
    force_path_style            = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_lockfile                = true
  }
}

provider "scaleway" {
  zone       = var.zone
  region     = var.region
  project_id = var.project_id
}
