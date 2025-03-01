
resource "google_cloud_scheduler_job" "monthly_update" {
  name        = "monthlyupdate"
  description = "Download csv and upload google cloud storage and bigquery"
  schedule    = "8 of month 10:00"
  time_zone   = "Asia/Tokyo"

  retry_config {
    retry_count          = 5
    max_backoff_duration = "604800s"
    max_retry_duration   = "172800s"
    min_backoff_duration = "43200s"
  }

  http_target {
    http_method = "POST"
    uri         = local.ingest_flights_http_endpoint
    body        = base64encode(jsonencode(local.ingest_flights_monthly_req_body))
    headers = {
      "Content-Type" = "application/json"
    }
    oidc_token {
      service_account_email = google_service_account.svc_monthly_ingest.email
      audience              = local.ingest_flights_http_endpoint
    }
  }
}