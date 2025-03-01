// This service is deployed in advance
data "google_cloud_run_service" "ingest_flights_monthly" {
  name     = "ingest-flights-monthly"
  location = local.region
  project  = data.google_project.project.project_id
}