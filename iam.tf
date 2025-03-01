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

resource "google_project_iam_member" "bind_bq_job_user" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.jobUser"

  member = "serviceAccount:${google_service_account.svc_monthly_ingest.email}"
}

resource "google_project_iam_member" "bind_job_invoker" {
  project = data.google_project.project.project_id
  role    = "roles/run.invoker"

  member = "serviceAccount:${google_service_account.svc_monthly_ingest.email}"

}