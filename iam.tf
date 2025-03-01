// principals
resource "google_service_account" "svc_monthly_ingest" {
  account_id   = "svc-monthly-ingest"
  display_name = "flights monthly ingest"
}

// policies
data "google_iam_policy" "storage_admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${google_service_account.svc_monthly_ingest.email}"
    ]
  }
}

resource "google_project_iam_binding" "bind_bq_job_user" {
  project = data.google_project.project.id
  role    = "roles/bigquery.jobUser"

  members = [
    "serviceAccount:${google_service_account.svc_monthly_ingest.email}"
  ]
}