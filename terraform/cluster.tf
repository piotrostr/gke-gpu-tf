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
    // Machine_type is optional (will use the default value of e2-medium)
    preemptible = true
    image_type  = "ubuntu"
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
    labels = {
      "nvidia.com/gpu" = "true"
    }

    // Taints mean that pods will only get scheduled onto nodes of this pool
    // in case of the pods' toleration matching the key/value/effect below.
    taint = [{
      key    = "nvidia.com/gpu"
      value  = "true"
      effect = "NO_SCHEDULE"
    }]

    // Partitioning enables sharing gpu between pods
    //
    // Unfortunately, there is no option to use tesla t4 etc under kubernetes
    // through terraform, the tesla a100 is the only gpu supported
    //
    // It is possible to create a cluster with smaller gpus through gcloud but
    // then the partitioning is not possible
    guest_accelerator = [{
      gpu_partition_size = "1g.5gb"
      type               = "nvidia-tesla-a100"
      count              = 1
    }]
  }
}
