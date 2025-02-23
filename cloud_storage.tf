resource "google_storage_bucket" "flights" {
  // Globally unique name
  name          = "${var.project}-ds"
  location      = local.bucket_location
  force_destroy = true

  labels = {
    budget-key = local.billing_key_value
  }
}