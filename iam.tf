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
  member  = "serviceAccount:${google_service_account.svc_monthly_ingest.email}"
  project = data.google_project.project.project_id
  role    = "roles/bigquery.jobUser"
}

resource "google_project_iam_member" "bind_job_invoker" {
  member  = "serviceAccount:${google_service_account.svc_monthly_ingest.email}"
  project = data.google_project.project.project_id
  role    = "roles/run.invoker"
}

//resource "google_iap_tunnel_instance_iam_member" "user_tunneling" {
//  instance = google_compute_instance.cloud_sql_auth_proxy.name
//  member   = "user:john-doe@google.com"
//  role     = "roles/iap.tunnelResourceAccessor"
//}