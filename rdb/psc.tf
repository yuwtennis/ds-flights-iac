// Private service connect
// Cloud SQL
resource "google_compute_address" "cloud_sql_ep" {
  name         = "cloud-sql-ep"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork.id
  address      = var.psc_static_ipv4_addr
}

resource "google_compute_forwarding_rule" "psc_cloud_sql" {
  name                  = "psc-cloud-sql"
  region                = var.region
  network               = var.network.id
  ip_address            = google_compute_address.cloud_sql_ep.self_link
  load_balancing_scheme = ""
  target                = google_sql_database_instance.flights.psc_service_attachment_link
}