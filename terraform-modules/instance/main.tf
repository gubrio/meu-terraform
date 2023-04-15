# main.tf

variable "vm_tags" {
  type    = list(string)
  default = []
}

# Configure o provedor do Google Cloud
provider "google" {
  credentials = file("chave aqui")
  project     = "handy-droplet-379616"
  region      = "us-central1"
}

# Crie uma rede de VPC
resource "google_compute_network" "vpc_network" {
  name = "my-vpc-network"
}

# Crie uma sub-rede dentro da VPC
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "my-vpc-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}

# Crie uma instância de VM na sub-rede
resource "google_compute_instance" "vm_instance" {
  name         = "my-vm-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnet.name
  }

  # Defina tags para a instância de VM
  tags = var.vm_tags
}

# Crie uma regra de firewall para permitir tráfego na porta 22 (SSH)
resource "google_compute_firewall" "firewall_rule" {
  name       = "allow-ssh"
  network    = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  # Associe a regra de firewall à tag da instância de VM
  target_tags = var.vm_tags

}
