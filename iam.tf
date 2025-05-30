// principals
resource "google_service_account" "svc_monthly_ingest" {
  account_id   = "svc-monthly-ingest"
  display_name = "flights monthly ingest"
}
resource "google_service_account" "svc_dataflow_flight_job" {
  account_id   = "svc-dataflow-flight-job"
  display_name = "SA for dataflow job for flight"
}

resource "google_service_account" "svc_vertex_ai_wkbench" {
  account_id   = "svc-vertex-ai-wkbench"
  display_name = "SA for vertex ai workbench"
}

// policies
data "google_iam_policy" "storage_admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${google_service_account.svc_monthly_ingest.email}",
      "serviceAccount:${google_service_account.svc_dataflow_flight_job.email}"
    ]
  }
}

resource "google_project_iam_binding" "bind_bq_job_user" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.jobUser"
  members = [
    "serviceAccount:${google_service_account.svc_monthly_ingest.email}",
    "serviceAccount:${google_service_account.svc_dataflow_flight_job.email}",
    "serviceAccount:${google_service_account.svc_vertex_ai_wkbench.email}"
  ]
}

resource "google_project_iam_binding" "bind_job_invoker" {
  project = data.google_project.project.project_id
  role    = "roles/run.invoker"
  members  = [
    "serviceAccount:${google_service_account.svc_monthly_ingest.email}"
  ]
}

resource "google_project_iam_binding" "bind_dataflow_job_runner" {

  project = data.google_project.project.project_id
  role    = "roles/dataflow.worker"
  members  = [
    "serviceAccount:${google_service_account.svc_dataflow_flight_job.email}"
  ]
}

resource "google_project_iam_binding" "bind_pubsub_editor" {

  project = data.google_project.project.project_id
  role    = "roles/pubsub.editor"
  members  = [
    "serviceAccount:${google_service_account.svc_dataflow_flight_job.email}"
  ]
}

//resource "google_iap_tunnel_instance_iam_member" "user_tunneling" {
//  instance = google_compute_instance.cloud_sql_auth_proxy.name
//  member   = "user:john-doe@google.com"
//  role     = "roles/iap.tunnelResourceAccessor"
//}