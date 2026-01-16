resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.base_address_space]
}

locals {
  alpha_address_prefix   = cidrsubnet(var.base_address_space, 2, 0)
  bravo_address_prefix   = cidrsubnet(var.base_address_space, 2, 1)
  charlie_address_prefix = cidrsubnet(var.base_address_space, 2, 2)
  delta_address_prefix   = cidrsubnet(var.base_address_space, 2, 3)
}

#10.113.0.0/24
resource "azurerm_subnet" "alpha" {
  name                 = "snet-alpha"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.alpha_address_prefix]
}

# 10.113.0.0/24
resource "azurerm_subnet" "bravo" {
  name                 = "snet-bravo"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.bravo_address_prefix]
}

# 10.113.0.0/24
resource "azurerm_subnet" "charlie" {
  name                 = "snet-charlie"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.charlie_address_prefix]
}

# 10.113.0.0/24
resource "azurerm_subnet" "delta" {
  name                 = "snet-delta"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.delta_address_prefix]
}

resource "azurerm_network_security_group" "remote_access" {
  name                = "nsg-${var.application_name}-${var.environment_name}-remote-access"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = chomp(data.http.my_ip.request_body)
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "alpha_remote_access" {
  subnet_id                 = azurerm_subnet.alpha.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}

data "http" "my_ip" {
  url = "https://ipconfig.me/ip"
}

resource "random_integer" "randint" {
  min = 10000
  max = 99999
}


data "azurerm_log_analytics_workspace" "observability" {
  resource_group_name = "rg-observability-dev"
  name                = "log-observability-dev"
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "diag-${var.application_name}-${var.environment_name}-${random_integer.randint.result}"
  target_resource_id         = azurerm_virtual_network.main.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.observability.id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
