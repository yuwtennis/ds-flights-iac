
// https://cloud.google.com/sql/docs/postgres/configure-private-service-connect#create-endpoint-manually
resource "google_sql_database_instance" "flights" {
  // Deal with name cannot be reused
  // https://cloud.google.com/sql/docs/error-messages#errors-u
  name             = "flights"
  database_version = "POSTGRES_17"
  region           = var.region

  settings {
    tier                  = "db-f1-micro" # Shared, 1 CPU, 3840 MB
    edition               = "ENTERPRISE"
    availability_type     = "ZONAL"
    connector_enforcement = "REQUIRED"

    backup_configuration {
      enabled            = true
      binary_log_enabled = false
    }

    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = [var.project_id]
      }

      ipv4_enabled = false
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "bts" {
  name     = "bts"
  instance = google_sql_database_instance.flights.name
}
