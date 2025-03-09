// Network requirements
// 1. Private network hosting compute engines without external ip
// 2. Compute engine will have private access to the cloud storage from the subnet
// 3. Firewall policies will be enforced at compute engine level. Allowing ANY for egress packets
// and only 5432 for ingress packets
//
// Architecture will be similar to the one in the document
// https://cloud.google.com/vpc/docs/private-google-access#example

// Base
resource "google_compute_network" "vpc" {
  name                    = "dsongcp"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "prv-subnet"
  ip_cidr_range            = "192.168.0.0/28"
  network                  = google_compute_network.vpc.id
  region                   = local.region
  private_ip_google_access = true
}

// Nat for pulling container from public repos
resource "google_compute_router" "router" {
  name    = "cloud-router"
  region  = google_compute_subnetwork.private_subnet.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "public_nat" {
  name                               = "public-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}