// Firewalls
// TODO Refactor
resource "google_compute_firewall" "ingress_postgresql_rule" {
  name        = "ingress-postgresql-rule"
  network     = var.network.id
  description = ""

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  direction     = "INGRESS"
  target_tags   = ["ingress-postgresql"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ingress_deny_all_rule" {
  name        = "ingress-deny-all-rule"
  network     = var.network.id
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
  network     = var.network.id
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
  network   = var.network.id
  direction = "EGRESS"

  deny {
    protocol = "all"
  }

  destination_ranges = ["${google_compute_forwarding_rule.psc_cloud_sql.ip_address}/32"]
  priority           = 65535
}

resource "google_compute_firewall" "cloud_sql_ep_allow_rule" {
  name      = "cloud-sql-ep-allow-posgresql-rule"
  network   = var.network.id
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  destination_ranges = ["${google_compute_forwarding_rule.psc_cloud_sql.ip_address}/32"]
  priority           = 100
}
