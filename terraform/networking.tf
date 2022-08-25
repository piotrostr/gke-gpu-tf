resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress"
    annotations = {
      "cloud.google.com/neg" = jsonencode({ "ingress" : "true" })
    }
  }

  spec {
    rule {
      // Hostname can be specified with subdomains
      // host = "example.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "cpu-api-service"
            service_port = 8080
          }
        }

        path {
          path = "/gpu"
          backend {
            service_name = "gpu-api-service"
            service_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "cpu_api_service" {
  metadata {
    name = "cpu-api-service"
    labels = {
      name = "cpu-api-service"
    }
  }

  spec {
    type = "NodePort" // or NodePort in case of using nginx Ingress
    selector = {
      "name" = "cpu-api"
    }

    port {
      port        = 8080
      target_port = 8080
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
    type = "NodePort"
    selector = {
      "name" = "gpu-api"
    }

    port {
      port        = 8000
      target_port = 8000
    }
  }
}
