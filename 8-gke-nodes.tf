resource "google_service_account" "gke" {
  account_id = "demo-gke-sa"
}

resource "google_project_iam_member" "gke_logging" {
  project = local.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "gke_metrics" {
  project = local.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_container_node_pool" "general" {
  name    = "general"
  cluster = google_container_cluster.gke.id

  node_count = 2 
  # autoscaling {
  #   total_min_node_count = 2
  #   total_max_node_count = 3
  # }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-standard-2"

    labels = {
      role = "general"
    }

    service_account = google_service_account.gke.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
