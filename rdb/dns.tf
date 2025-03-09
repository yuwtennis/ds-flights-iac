// DNS
resource "google_dns_managed_zone" "dsongcp" {
  name        = "dsongcp"
  dns_name    = "${var.region}.sql.goog."
  description = "Private zone exclusive to dsongcp"
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = var.network.id
    }
  }
}

resource "google_dns_record_set" "cloudsql" {
  managed_zone = google_dns_managed_zone.dsongcp.name
  name         = google_sql_database_instance.flights.dns_name
  type         = "A"
  rrdatas      = [google_compute_forwarding_rule.psc_cloud_sql.ip_address]
  ttl          = 300
}

resource "google_dns_record_set" "cloudsql_domain_ownership" {
  managed_zone = google_dns_managed_zone.dsongcp.name
  name         = google_sql_database_instance.flights.dns_name
  type         = "TXT"
  rrdatas      = [google_sql_database_instance.flights.connection_name]
  ttl          = 3600
}