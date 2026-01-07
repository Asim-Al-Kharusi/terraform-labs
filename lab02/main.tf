resource "azurerm_resource_group" "main" {
  name     = "rg-${var.group_name}-${var.env_name}"
  location = var.primary_location
}

resource "random_integer" "unq_id" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "sa_azure" {
  name                     = "${var.sa_backend_name}${random_integer.unq_id.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.primary_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "tf_state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.sa_azure.id
  container_access_type = "private"
}
