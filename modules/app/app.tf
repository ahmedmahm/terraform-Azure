provider "kubernetes" {
  config_path = var.kubeconfig_path
}
resource "kubernetes_deployment" "main" {
  metadata {
    name = var.name
    namespace = var.namespace
  }
  spec {
    replicas = var.replicas
    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge = 1
        max_unavailable = 0
      }
    }
    selector {
      match_labels = {
        app = var.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        automount_service_account_token = true
        container {
          name = var.name
          image = var.image
          image_pull_policy = "Always"
          env {
            name = "DELPHAI_ENVIRONMENT"
            value = var.delphai_env
          }
          port {
            container_port = var.app_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "main" {
  metadata {
    name = "svc-${var.name}"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.name
    }
    port {
      port = var.app_port
      target_port = var.app_port
      protocol = "TCP"
    }
  }
}

resource "kubernetes_ingress" "main" {
  count = var.has_ingress ? 1 : 0
  metadata {
    name = var.name
    namespace = var.namespace
  }
  spec {
    tls {
      hosts = [local.host]
      secret_name = "wildcard-cert"
    }
    rule {
      host = local.host
      http {
        path {
          backend {
            service_name = kubernetes_service.main.metadata[0].name
            service_port = var.app_port
          }
        }
      }
    }
  }
}