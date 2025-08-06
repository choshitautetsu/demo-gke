# Cloud NAT 分配的一个静态公网 IP
resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.api]
}

# 云路由器，用来管理 NAT 配置
resource "google_compute_router" "router" {
  name    = "router"
  region  = local.region
  network = google_compute_network.vpc.id
}

# NAT 配置本体，它绑定刚才创建的路由器，指定 NAT IP 和需要 NAT 的子网
# Cloud NAT 是用来使 Kubernetes 集群中的 Pod（或者在私有子网中的资源）能够访问外部互联网的，特别是在私有集群或者子网没有公网 IP 的场景。Pod 的对外连接会经过这个 NAT 网关转发，实现安全的公网访问
resource "google_compute_router_nat" "nat" {
  name   = "nat"
  region = local.region
  router = google_compute_router.router.name

  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ips                            = [google_compute_address.nat.self_link]

  subnetwork {
    name                    = google_compute_subnetwork.private.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
