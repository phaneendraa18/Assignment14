resource "google_compute_network" "vpc_network" {
  project                 = "pj-project-374418"
  name                    = "vpc-test-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}
resource "google_compute_subnetwork" "test_subnetwork" {
  project       = "pj-project-374418"
  name          = "test-subnetwork"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.0.0.0/22"
  region        = "us-central1"
}
resource "google_compute_instance" "default" {
  project      = "pj-project-374418"
  count        = 2
  name         = "tf-vm-${count.index}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["fire1"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.test_subnetwork.name
    access_config {
      // Ephemeral public IP
    }
  }
}
