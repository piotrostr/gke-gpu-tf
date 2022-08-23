resource "kubernetes_deployment" "cpu_api" {
  metadata {
    name = "cpu-api"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "name" = "cpu-api"
      }
    }

    template {
      metadata {
        name = "cpu-api"
        labels = {
          "name" = "cpu-api"
        }
      }

      spec {
        container {
          name  = "where-api"
          image = "docker.io/piotrostr/hello-world"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "gpu_api" {
  metadata {
    name = "gpu-api"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "name" = "gpu-api"
      }
    }

    template {
      metadata {
        name = "gpu-api"
        labels = {
          "name" = "gpu-api"
        }
      }

      spec {
        // Matching the taint of the gpu node pool
        toleration {
          key    = "nvidia.com/gpu"
          value  = "true"
          effect = "NoSchedule"
        }

        // In case of future use with more node pools, also include affinity
        // affinity {
        //   node_affinity {
        //     required_during_scheduling_ignored_during_execution {
        //       node_selector_term {
        //         match_expressions {
        //           key = "nvidia.com/gpu"
        //           operator = "Exists"
        //         }
        //       }
        //     }
        //   }
        // }

        container {
          name  = "cuda-smoke-api"
          image = "docker.io/piotrostr/does-cuda-work"

          port {
            container_port = 8000
          }
        }
      }
    }
  }
}
