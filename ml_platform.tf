resource "google_workbench_instance" "flights" {
  location = local.region
  name     = "flights"

  gce_setup {
    machine_type = "n1-standard-4"

    disable_public_ip = true

    boot_disk {
      disk_size_gb = 50
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
  desired_state = "STOPPED"
}