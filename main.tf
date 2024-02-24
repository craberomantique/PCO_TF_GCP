resource "google_compute_network" "vpc_network" {
  name                    = "mon-premier-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "mon-premier--subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc_network.id
}

# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = "vmdetest"
  machine_type = "f1-micro"
  zone         = "us-west1-a"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install prerequis
  metadata_startup_script = "sudo apt-get update; sudo apt-get install docker docker-compose git curl -y; sudo git clone https://github.com/craberomantique/Odoo-v17_Automatic-deployement-services.git; cd Odoo-v17_Automatic-deployement-services; sudo docker-compose up -d"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
#Firewall rule
resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "nginx-proxy-manager" {
  name = "allow-nginx-proxy-manager"
  allow {
    ports    = ["42081"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nginx-proxy-manager"]
}

resource "google_compute_firewall" "portainer" {
  name = "allow-portainer"
  allow {
    ports    = ["42090"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["portainer"]
}

resource "google_compute_firewall" "kuma" {
  name = "allow-kuma"
  allow {
    ports    = ["42031"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kuma"]
}

resource "google_compute_firewall" "odoo17" {
  name = "allow-odoo17"
  allow {
    ports    = ["42017"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["odoo17"]
}
