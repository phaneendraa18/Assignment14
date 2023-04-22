variables "project"{
}
variables "network"{
}

variable "subnetwork"{
}

variable "vm_count"{
}

variable "ip_subnet_cidr_range"{
}

variable "vm_machine_type"{
}

variable "region"{
}

variable "zone"{
}


resource "google_compute_network" "vpc_network" {
  project                 = var.project
  name                    = var.network
  auto_create_subnetworks = false
  mtu                     = 1460
}
resource "google_compute_subnetwork" "test_subnetwork" {
  project       = var.project
  name          = var.subnetwork
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.ip_subnet_cidr_range
  region        = var.region
}
resource "google_compute_instance" "default" {
  project      = var.project
  count        = vm_count
  name         = "tf-vm-${count.index}"
  machine_type = var.vm_machine_type
  zone         = var.zone

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
    subnetwork_project = var.project
    access_config {
      // Ephemeral public IP
    }
  }
}
