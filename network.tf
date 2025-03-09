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

// Private service connect
// Cloud SQL
resource "google_compute_address" "cloud_sql_ep" {
  name         = "cloud-sql-ep"
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.private_subnet.id
  address      = "192.168.0.4"
}

resource "google_compute_forwarding_rule" "psc_cloud_sql" {
  name                  = "psc-cloud-sql"
  region                = local.region
  network               = google_compute_network.vpc.id
  ip_address            = google_compute_address.cloud_sql_ep.self_link
  load_balancing_scheme = ""
  target                = google_sql_database_instance.flights.psc_service_attachment_link
}

// Firewalls
// TODO Refactor
resource "google_compute_firewall" "ingress_postgresql_rule" {
  name        = "ingress-postgresql-rule"
  network     = google_compute_network.vpc.id
  description = ""

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  direction     = "INGRESS"
  target_tags   = ["ingress-postgresql"]
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "ingress_iap_ssh_forwarding_rule" {
  name        = "ingress-iap-ssh-forwarding-rule"
  network     = google_compute_network.vpc.id
  description = ""

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  direction     = "INGRESS"
  target_tags   = ["ingress-iap"]
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "ingress_deny_all_rule" {
  name        = "ingress-deny-all-rule"
  network     = google_compute_network.vpc.id
  description = ""

  deny {
    protocol = "all"
  }

  direction     = "INGRESS"
  target_tags   = ["deny-all"]
  source_ranges = ["0.0.0.0/0"]
  priority      = 65535
}

resource "google_compute_firewall" "egress_tcp_any_rule" {
  name        = "egress-tcp-any-rule"
  network     = google_compute_network.vpc.id
  description = ""

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["egress-postgresql"]
}

resource "google_compute_firewall" "cloud_sql_ep_deny_rule" {
  name      = "cloud-sql-ep-deny-all"
  network   = google_compute_network.vpc.id
  direction = "EGRESS"

  deny {
    protocol = "all"
  }

  destination_ranges = ["${google_compute_forwarding_rule.psc_cloud_sql.ip_address}/32"]
  priority           = 65535
}

resource "google_compute_firewall" "cloud_sql_ep_allow_rule" {
  name      = "cloud-sql-ep-allow-posgresql-rule"
  network   = google_compute_network.vpc.id
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  destination_ranges = ["${google_compute_forwarding_rule.psc_cloud_sql.ip_address}/32"]
  priority           = 100
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