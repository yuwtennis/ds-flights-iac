
// https://cloud.google.com/sql/docs/postgres/configure-private-service-connect#create-endpoint-manually
resource "google_sql_database_instance" "flights" {
  name             = "flights"
  database_version = "POSTGRES_17"
  region           = local.region

  settings {
    tier              = "db-custom-1-3840" # 1 CPU, 3840 MB
    edition           = "ENTERPRISE"
    availability_type = "REGIONAL"

    backup_configuration {
      enabled            = true
      binary_log_enabled = false
    }

    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = []
      }

      ipv4_enabled = false
    }
  }

  deletion_protection = false
}