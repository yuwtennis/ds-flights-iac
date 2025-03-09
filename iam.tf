// principals
resource "google_service_account" "svc_monthly_ingest" {
  account_id   = "svc-monthly-ingest"
  display_name = "flights monthly ingest"
}

resource "google_service_account" "cloud_sql_auth_proxy" {
  account_id   = "cloud-sql-auth-proxy"
  display_name = "SA for cloud sql auth proxy compute instnace"
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

resource "google_project_iam_member" "bind_log_writer" {
  member  = "serviceAccount:${google_service_account.cloud_sql_auth_proxy.email}"
  project = data.google_project.project.project_id
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "bind_cloud_sql_client" {
  member  = "serviceAccount:${google_service_account.cloud_sql_auth_proxy.email}"
  project = data.google_project.project.project_id
  role    = "roles/cloudsql.client"
}

resource "google_project_iam_member" "bind_cloud_sql_csv_import" {
  member  = "serviceAccount:${google_sql_database_instance.flights.service_account_email_address}"
  project = data.google_project.project.project_id
  role    = "roles/storage.objectViewer"
}

//resource "google_iap_tunnel_instance_iam_member" "user_tunneling" {
//  instance = google_compute_instance.cloud_sql_auth_proxy.name
//  member   = "user:john-doe@google.com"
//  role     = "roles/iap.tunnelResourceAccessor"
//}