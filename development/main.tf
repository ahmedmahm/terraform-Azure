provider "azurerm" {
    version ="2.2.0"
    features {}
}
terraform {
    backend "azurerm" {
        resource_group_name  = "remote-state"
        storage_account_name = "devblobstatestorage"
        container_name       = "tfstate"
        key                  = "dev.tfstate"
    }
}

module "networking" {
    source = "../modules/networking"
    web_server_location      = var.web_server_location
    web_server_rg            = var.web_server_rg
    resource_prefix          = var.resource_prefix
    web_server_address_space = var.web_server_address_space
    web_server_address_prefix= var.web_server_address_prefix
    web_server_name          = var.web_server_name
}

module "cluster" {
    source = "../modules/cluster"
    serviceprinciple_id      = var.serviceprinciple_id
    serviceprinciple_key     = var.serviceprinciple_key
    kubernetes_version       = var.kubernetes_version
    adminname                = var.adminname
    ssh_key                  = var.ssh_key
    web_server_location      = var.web_server_location
    web_server_rg            = var.web_server_rg
}
