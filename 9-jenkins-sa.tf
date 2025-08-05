# 1. 创建一个专用 ServiceAccount
# resource "google_service_account" "jenkins_gke_sa" {
#   account_id   = "jenkins-gke-sa"
#   display_name = "Jenkins GKE CI/CD Service Account"
# }

# # 2. 授予控制 GKE 集群的 IAM 权限（例如 Developer，Viewer 可只查阅）
# resource "google_project_iam_member" "jenkins_gke_developer" {
#   project = local.project_id
#   role    = "roles/container.developer"
#   member  = "serviceAccount:${google_service_account.jenkins_gke_sa.email}"
# }

# resource "google_service_account_key" "jenkins_gke_sa" {
#   service_account_id = google_service_account.jenkins_gke_sa.name
#   keepers = {
#     # optional: force recreation by changing this value
#     expire_time = "2025-12-31T23:59:59Z"
#   }
#   private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"
# }

# （可选）如需管理集群也可以赋予 "roles/container.admin"
# resource "google_project_iam_member" "jenkins_gke_admin" {
#   project = local.project_id
#   role    = "roles/container.admin"
#   member  = "serviceAccount:${google_service_account.jenkins_gke.email}"
# }

# # 3. 如需操作 GCR 镜像仓库，另加 storage 权限
# resource "google_project_iam_member" "jenkins_gke_gcr" {
#   project = local.project_id
#   role    = "roles/storage.objectViewer"
#   member  = "serviceAccount:${google_service_account.jenkins_gke.email}"
# }
