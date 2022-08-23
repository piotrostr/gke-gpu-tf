resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress"
  }
  spec {
    rule {
      http {
        path {
          path = "/cpu"
          backend {
            service {
              name = "cpu-api-service"

              port {
                number = 8080
              }
            }
          }
        }

        path {
          path = "/gpu"
          backend {
            service {
              name = "gpu-api-service"

              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "gpu_api_service" {
  metadata {
    name = "gpu-api-service"
    labels = {
      name = "gpu-api-service"
    }
  }

  spec {
    type = "NodePort" // or NodePort in case of using nginx Ingress
    selector = {
      "name" = "gpu-api"
    }

    port {
      port        = 8000
      target_port = 8000
    }
  }
}

