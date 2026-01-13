# Setting Up Remote Backend with Azure
In this lab,  I will go over how to set up a remote backend on terraform to store state files in Azure Blob Storage. This is a continuation of lab02 where I set up the necessary infrastructure to store the state file. Using the remote backend, I will also provision a log analytics workspace to set up potential observability accross a multiple workloads. 

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

## Observability
The reason I've chosen to compartmentalise the Log Analytics Workspace into its own resource group is because this could then be used as a shared service similar to the state file stored in the remote backend.  

Key benefits of having the observability as a shared service: 
* Centralised management
* Ability to query accross multiple resource logs
* Potential cost savings

However, the most common use case of obvservability would be to include it into a resource group that contains all of an application's resource. This would be the better option for centralising data, logs, metrics etc associated only with that particular application as opposed to enterprise wide.


