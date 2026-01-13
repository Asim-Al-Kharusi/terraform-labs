# Lab04 - Azure Key Vault and Role Assignment 
In this lab I will be provisioning a key vault to secrets and keys as well as assigning a role to myself to manage the key vault. 

## Azure Key Vault 
The main reason to use a key vault is store secrets and keys securely on the cloud. With this, resources or user that may require access can be given a role assignment or an access policy can be put in place to configure the appropriate permissions 

![Warning]
It is important when assigning role to always keep secuirity best practices in mind and assign according to least priviledges required.

I used the following block to provision the key vault:
```hcl
resource "azurerm_key_vault" "kv" {
  name                       = "kv-${var.application_name}-${var.environment_name}-${random_integer.randint.result}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
}
``` 
As the key vault name needed to be globaly unique, I created a `random_integer` resource to get a unique suffix. 

To obtain to the tenant_id of the current user (myself), I derived the client configuration object by using the following: 
```hcl 
data "azurerm_client_config" "current" {}
```

I set `rbac_authorization_enabled = true` so that the key vault will accept RBAC assignments. 

## Role Assignment 
For this lab, I went ahead and assigned myself admin priviledges to the key vault through the following: 
```hcl 
resource "azurerm_role_assignment" "name" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
```
The scope was set to the key vault meaning that when applied I was granted with the admin role, giving me permission to manage the entire resource. 

