
// Topic
resource "google_pubsub_topic" "flight_topics" {
  for_each = { for elem in local.event_topics : "flight.${elem}" => elem }

  name = each.value
}

// Subscription
resource "google_pubsub_subscription" "flight_subscriptions" {
  for_each = google_pubsub_topic.flight_topics

  name  = each.key
  topic = each.value.id
}