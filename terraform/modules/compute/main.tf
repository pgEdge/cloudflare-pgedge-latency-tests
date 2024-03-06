
resource "google_compute_instance" "this" {

  zone         = var.zone
  machine_type = var.machine_type
  name         = var.name

  boot_disk {
    auto_delete = true
    device_name = var.name
    initialize_params {
      image = var.boot_image
      size  = 10
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = { goog-ec-src = "vm_add-tf" }

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/${var.project_name}/regions/${var.region}/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}

output "instance_ip" {
  value = google_compute_instance.this.network_interface[0].access_config[0].nat_ip
}
