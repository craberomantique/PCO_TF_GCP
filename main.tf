resource "google_compute_network" "vpc_network" {
  name                    = "defaut"
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
  metadata_startup_script = "sudo apt-get update"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
#Firewall rule
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http"]
}

resource "google_compute_firewall" "https" {
  name    = "allow-https"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https"]
}
resource "google_compute_firewall" "nginx_proxy_manager" {
  name    = "allow-nginx-proxy-manager"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "42081"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nginx-proxy-manager"]
}

resource "google_compute_firewall" "portainer" {
  name    = "allow-portainer"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["42090"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["portainer"]
}

resource "google_compute_firewall" "uptime_kuma" {
  name    = "allow-uptime-kuma"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["42031"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["uptime-kuma"]
}

resource "google_compute_firewall" "odoo17" {
  name    = "allow-odoo17"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["42017", "42018"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["odoo17"]
}


