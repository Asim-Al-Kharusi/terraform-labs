resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "random_integer" "randint" {
  min = 100000
  max = 999999
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-${var.application_name}-${var.environment_name}-${random_integer.randint.result}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
}

resource "azurerm_role_assignment" "name" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

data "azurerm_log_analytics_workspace" "observability" {
  resource_group_name = "rg-observability-dev"
  name                = "log-observability-dev"
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "diag-${var.application_name}-${var.environment_name}-${random_integer.randint.result}"
  target_resource_id         = azurerm_key_vault.kv.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
