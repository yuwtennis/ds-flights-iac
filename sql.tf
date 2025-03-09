
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

// https://cloud.google.com/sql/docs/postgres/configure-private-service-connect#create-endpoint-manually
resource "google_sql_database_instance" "flights" {
  name             = "flights-${random_string.random.result}"
  database_version = "POSTGRES_17"
  region           = local.region

  settings {
    tier              = "db-f1-micro" # Shared, 1 CPU, 3840 MB
    edition           = "ENTERPRISE"
    availability_type = "ZONAL"

    backup_configuration {
      enabled            = true
      binary_log_enabled = false
    }

    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = [data.google_project.project.project_id]
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
