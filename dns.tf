// DNS
resource "google_dns_managed_zone" "dsongcp" {
  name        = "dsongcp"
  dns_name    = "${local.region}.sql.goog."
  description = "Private zone exclusive to dsongcp"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc.id
    }
  }
}

resource "google_dns_record_set" "cloudsql" {
  managed_zone = google_dns_managed_zone.dsongcp.name
  name         = google_sql_database_instance.flights.dns_name
  type         = "A"
  rrdatas      = [google_compute_forwarding_rule.psc_cloud_sql.ip_address]
}