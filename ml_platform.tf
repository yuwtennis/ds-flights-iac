resource "google_workbench_instance" "flights" {
  count = local.workbench_enabled ? 1 : 0

  location = "asia-northeast1-a"
  name     = "flights"

  gce_setup {
    machine_type = "n2-standard-2"

    disable_public_ip = true

    boot_disk {
      disk_size_gb = 150
      disk_type = "PD_STANDARD"
    }

    service_accounts {
      email = google_service_account.svc_vertex_ai_wkbench.email
    }

    network_interfaces {
      network = google_compute_network.vpc.id
      subnet = google_compute_subnetwork.private_subnet.id
      nic_type = "GVNIC"
    }

    metadata = {
      disable-mixer = "true"
    }
  }

  disable_proxy_access = false
}