output "jenkins_gke_sa_key" {
  value     = google_service_account_key.jenkins_gke_sa.private_key
  sensitive = true
}
