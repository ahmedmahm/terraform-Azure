data "azurerm_subscription" "current" {}
resource "random_password" "sp_password" {
  length = 16
  number = false
  special = false
}
resource "azuread_application" "dev" {
  name = var.adminname
}
resource "azuread_service_principal" "dev" {
  application_id = azuread_application.dev.application_id
}
resource "azuread_service_principal_password" "dev" {
  service_principal_id = azuread_service_principal.dev.id
  value = random_password.sp_password.result 
  end_date_relative = "24000h"
}
