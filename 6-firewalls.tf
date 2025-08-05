resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # 限制来源 IP 为 Google IAP 的 IP 范围
  source_ranges = ["35.235.240.0/20"]
}


