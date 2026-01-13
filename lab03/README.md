# Setting Up Remote Backend with Azure
In this lab,  I will go over how to set up a remote backend on terraform to store state files in Azure Blob Storage. This is a continuation of lab02 where I set up the necessary infrastructure to store the state file. 

## Remote Backend Block 
To refer to a remote backend on terraform, I declare the following `backend` block in the `terraform` block within the `versions.tf` file.

```hcl 
backend "azurerm" {
    resource_group_name  = "rg-terraform-state-dev"
    storage_account_name = "tfsa35973"
    container_name       = "tfstate"
    key                  = "observability-dev"
}
```
Notice that the backend block requires the names of the resource group, storage account and container of where the state file is to be stored (or where it already exsists) as well as a key for the state file itself. this acts a unique identifier for the state file which will also be to used to name the file as well. 

