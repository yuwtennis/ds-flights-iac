
// Module which bootstraps cloud sql with secure access
module "rdb" {
  source = "./rdb"

  count = local.rdb_enabled ? 1 : 0
  network = {
    id        = google_compute_network.vpc.id
    self_link = google_compute_network.vpc.self_link
  }
  project_id = data.google_project.project.project_id
  region     = local.region
  subnetwork = {
    id        = google_compute_subnetwork.private_subnet.id
    self_link = google_compute_subnetwork.private_subnet.self_link
  }
  psc_static_ipv4_addr = "192.168.0.4"
}