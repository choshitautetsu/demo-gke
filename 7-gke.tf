resource "google_container_cluster" "gke" {
  name                     = "demo-gke"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 2
  network                  = google_compute_network.vpc.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  networking_mode          = "VPC_NATIVE"

  deletion_protection = false

  # Optional, if you want multi-zonal cluster
  # node_locations = ["us-central1-b"]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }

  private_cluster_config {
    #节点没有公共IP，节点和Pod只能使用私有IP地址
    enable_private_nodes    = true
    #GKE控制面的API服务器（Control Plane）只有公共IP可访问，不启用私有访问端点
    enable_private_endpoint = false
    #用于为控制面私有IP分配一个CIDR段（在本例中，虽然关闭了private_endpoint，但配置了该字段作为限制）
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }

}
