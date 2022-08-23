data "google_client_config" "provider" {}

resource "google_container_cluster" "cluster" {
  name               = "cluster"
  location           = "us-central1-a"
  initial_node_count = 1
  // enable_tpu = true
  // enable_autopilot = true
}

provider "kubernetes" {
  host  = "https://${google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  )
}

resource "google_container_node_pool" "cpu_intensive" {
  name       = "cpu-intensive"
  cluster    = google_container_cluster.cluster.name
  location   = "us-central1-a"
  node_count = 1

  node_config {
    // machine_type is optional (will use the default value of e2-medium)
    preemptible = true
    image_type  = "ubuntu"
    taint = [{
      key    = "nvidia.com/gpu"
      value  = "ANY" // TODO
      effect = "NO_SCHEDULE"
    }]
  }
}

resource "google_container_node_pool" "gpu_accelerated" {
  name       = "gpu-accelerated"
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  location   = "us-central1-a"

  node_config {
    preemptible  = true
    machine_type = "a2-highgpu-1g"
    image_type   = "ubuntu"
    guest_accelerator = [{
      count              = 1
      gpu_partition_size = "1g.5gb"
      type               = "nvidia-tesla-a100"
      // partitioning enables sharing gpu between pods unfortunately, there is
      // no option to use tesla t4 etc under kubernetes through terraform the
      // tesla a100 is the only supported
    }]
  }
}
