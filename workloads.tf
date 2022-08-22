resource "kubernetes_service" "cpu_api_service" {
  metadata {
    name = "cpu-api-service"
    labels = {
      name = "cpu-api-service"
    }
  }
  spec {
    selector = {
      "name" = "CpuApi"
    }
    port {
      port = 8080
      target_port = 8080
    }
    type = "LoadBalancer" // or NodePort in case of using nginx Ingress
  }
}

resource "kubernetes_deployment" "cpu_api" {
  metadata {
    name = "CpuApi"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        "name" = "CpuApi"
      }
    }

    template {
      spec {
        container {
          image = "piotrostr/where"
        }
        toleration {
          key = "CPU"
          value = "true"
        }
      }
    }
  }
}
