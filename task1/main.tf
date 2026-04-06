provider "google" {
  project = "devops-exam-492515"
  region  = "europe-west3"
}

# VPC (не буде падати якщо вже існує)
resource "google_compute_network" "vpc" {
  name                    = "batenchuk-vpc"
  auto_create_subnetworks = true

  lifecycle {
    prevent_destroy = true
  }
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

# VM (ГОЛОВНЕ)
resource "google_compute_instance" "vm" {
  name         = "batenchuk-node"
  machine_type = "e2-medium"
  zone         = "europe-west3-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "batenchuk-vpc"   # 👈 важливо (напряму назва)

    access_config {}
  }

  tags = ["http-server", "https-server"]
}

# Bucket (з новою назвою щоб не падало)
resource "google_storage_bucket" "bucket" {
  name     = "batenchuk-bucket-492515-1"
  location = "EU"

  force_destroy = true
}
