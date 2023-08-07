// Resource block to deploy VPC Network
resource "google_compute_network" "vpc" {
  project                         = var.project_id
  name                            = var.network["name"]
  routing_mode                    = var.network["routing_mode"]
  auto_create_subnetworks         = var.network["auto_create_subnetworks"]
  delete_default_routes_on_create = var.network["delete_default_routes_on_create"]
}

// Resource block to deploy SubNetworks
resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnetwork["name"]
  ip_cidr_range            = var.subnetwork["ip_cidr_range"]
  region                   = var.subnetwork["region"]
  private_ip_google_access = var.subnetwork["private_ip_google_access"]
  network                  = google_compute_network.vpc.id
}

// Resource block to deploy VPC firewall for IAP and Health Check CIDR ranges
resource "google_compute_firewall" "iap_ingress_fw" {
  project   = var.project_id
  name      = var.iap_firewall_name
  network   = google_compute_network.vpc.id
  priority  = 500
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = var.tags
}

resource "google_compute_firewall" "health_check_fw" {
  name      = "allow-health-check"
  network   = google_compute_network.vpc.id
  priority  = 300
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = var.tags
}

// Resource and Module block to deploy Cloud Router and Cloud NAT 
// (Required for installing packages from repos like apache, php etc)
module "cloud_nat" {
  source = "terraform-google-modules/cloud-nat/google"

  project_id = var.project_id

  create_router = true
  router        = var.cloud_router_name
  network       = google_compute_network.vpc.name

  name                               = var.cloud_nat_name
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetworks = [
    {
      name                     = google_compute_subnetwork.subnet.self_link
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    }
  ]
}

// Resource blocks to reserve Internal IP Address range for Private Service Connection (Private Service Access)
resource "google_compute_global_address" "ps_connection_cidr" {
  project = var.project_id

  name          = "ps-connection-cidr"
  address       = "10.0.60.0"
  prefix_length = 24
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  network       = google_compute_network.vpc.id
}

# Resource block to deploy Private Service Connection (Private Service Access)
resource "google_service_networking_connection" "ps_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.ps_connection_cidr.name]
}
