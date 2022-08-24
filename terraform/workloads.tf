resource "kubernetes_deployment" "cpu_api" {
  metadata {
    name = "cpu-api"
  }

  spec {
    replicas = 5

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
          resources {
            limits = {
              cpu    = "250m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "125m"  // multiples of 5
              memory = "256Mi" // multiples of 2
            }
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
    replicas = 5

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
          value  = "present"
          effect = "NoSchedule"
        }

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "nvidia.com/gpu"
                  operator = "Exists"
                }
              }
            }
          }
        }

        container {
          name  = "cuda-smoke-api"
          image = "docker.io/piotrostr/does-cuda-work"

          port {
            container_port = 8000
          }

          resources {
            limits = {
              cpu              = "4000m" // multiples of 5
              memory           = "10Gi"  // multiples of 2
              "nvidia.com/gpu" = 1       // there should be 7 units per a100
            }
            requests = {
              cpu              = "2000m"
              memory           = "5Gi"
              "nvidia.com/gpu" = 1
            }
          }
        }
      }
    }
  }
}
