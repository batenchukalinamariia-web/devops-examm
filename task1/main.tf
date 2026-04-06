provider "google" {
  project = "devops-exam"
  region  = "europe-west3"
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "batenchuk-vpc"
  auto_create_subnetworks = true
}

# Firewall
resource "google_compute_firewall" "firewall" {
  name    = "batenchuk-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8000", "8001", "8002", "8003"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# VM
resource "google_compute_instance" "vm" {
  name         = "batenchuk-node"
  machine_type = "e2-medium"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc.name

    access_config {}
  }
}

# Bucket
resource "google_storage_bucket" "bucket" {
  name     = "batenchuk-bucket-987654321"
  location = "EU"
}

# test
