data "google_client_config" "provider" {}

resource "google_container_cluster" "cluster" {
  name     = "cluster"
  location = "us-central1-a"
  initial_node_count = 1
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth.cluster_ca_certificate
  )
}

resource "google_container_node_pool" "cpu_intensive" {
  name       = "cpu-intensive"
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  node_config {
    taint = [ {
      key = "GPU"
      value = "true"
      effect = "NO_SCHEDULE"
    } ]
    image_type = "n2-highcpu-16"
  }
}

resource "google_container_node_pool" "gpu_accelerated" {
  name       = "gpu-accelerated"
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  node_config {
    image_type = "n2-standard-4"
    taint = [ {
      key = "CPU"
      value = "true"
      effect = "NO_SCHEDULE"
    }]
    guest_accelerator = [{
      count              = 1
      gpu_partition_size = "1g.5gb"
      type               = "nvidia-tesla-t4"
    }]
  }
}
