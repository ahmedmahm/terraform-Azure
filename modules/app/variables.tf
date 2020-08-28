variable "delphai_env" {}
variable "name" {}
variable "namespace" {}
variable "image" {}
variable "app_port" {}
variable "has_ingress" {
  default = false
}
variable "kubeconfig_path" {
  default = "~/.kube/config"
}
variable "replicas" {
  default = 3
}
variable "subdomain" {
  default = null
}
locals {
  domains = {
    "development" = "ayoayo.xyz"
  }
  domain = lookup(local.domains, var.delphai_env)
  host = var.subdomain != null ? "${var.subdomain}.${local.domain}" : local.domain
}