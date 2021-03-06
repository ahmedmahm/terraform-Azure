
resource "azurerm_kubernetes_cluster" "aks"{
    name = "development-aks"
    location = var.web_server_location
    resource_group_name = var.web_server_rg
    dns_prefix = "aks-dns"
    kubernetes_version = var.kubernetes_version

    default_node_pool {
        name = "default"
        node_count = 1
        vm_size = "Standard_E4s_v3"
        type    = "VirtualMachineScaleSets"
        os_disk_size_gb = 250
    }

    service_principal {
    client_id     = azuread_service_principal.dev.application_id
    client_secret = random_password.sp_password.result
  }

    linux_profile {
        admin_username = var.adminname
        ssh_key {
            key_data = var.ssh_key
        }
    }

    network_profile {
        network_plugin = "kubenet"
        load_balancer_sku = "Standard"
    }

    addon_profile {
        aci_connector_linux {
            enabled = false
        }

        azure_policy {
            enabled = false
        }

        http_application_routing {
            enabled = false
        }

        kube_dashboard {
            enabled = false
        }

        oms_agent {
            enabled = false
        }
    }

    

}