resource "google_service_account" "cloud_sql_auth_proxy" {
  account_id   = "cloud-sql-auth-proxy"
  display_name = "SA for cloud sql auth proxy compute instnace"
}

resource "google_project_iam_member" "bind_cloud_sql_csv_import" {
  member  = "serviceAccount:${google_sql_database_instance.flights.service_account_email_address}"
  project = var.project_id
  role    = "roles/storage.objectViewer"
}


resource "google_project_iam_member" "bind_log_writer" {
  member  = "serviceAccount:${google_service_account.cloud_sql_auth_proxy.email}"
  project = var.project_id
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "bind_cloud_sql_client" {
  member  = "serviceAccount:${google_service_account.cloud_sql_auth_proxy.email}"
  project = var.project_id
  role    = "roles/cloudsql.client"
}