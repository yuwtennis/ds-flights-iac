resource "google_storage_bucket" "flights" {
  // Globally unique name
  name          = "${var.project_id}-ds"
  location      = local.region
  force_destroy = true

  labels = {
    budget-key = local.billing_key_value
  }
}

resource "google_storage_bucket" "staging" {
  name                        = "${var.project_id}-cf-staging"
  location                    = local.region
  force_destroy               = true
  uniform_bucket_level_access = true

  labels = {
    budget-key = local.billing_key_value
  }
}

// storage admin will be the authoritative for this bucket
resource "google_storage_bucket_iam_policy" "staging_bucket_authoritative_policy" {
  bucket      = google_storage_bucket.staging.name
  policy_data = data.google_iam_policy.storage_admin.policy_data
}