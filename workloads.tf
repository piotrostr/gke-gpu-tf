resource "kubernetes_service" "cpu_api_service" {
  metadata {
    name = "cpu-api-service"
    labels = {
      name = "cpu-api-service"
    }
  }

  spec {
    type = "LoadBalancer" // or NodePort in case of using nginx Ingress
    selector = {
      "name" = "cpu-api"
    }

    port {
      port        = 8080
      target_port = 8080
    }
  }
}

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
          image = "docker.io/piotrostr/where"

          port {
            container_port = 8080
          }
        }

        toleration {
          key   = "CPU"
          value = "true"
        }
      }
    }
  }
}
