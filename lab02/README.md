# Lab02 - Azure infrastructure for a remote backend
In this lab,  I will be going over a small project I've put together to show case creating azure infrastructure for a remote backend. 

I went over the potential use cases of a remote backend in Lab01. This lab will focus on using the `azurerm` provider to create resource groups, storage accounts and blob containers for two seperate environments; 'dev' and 'prod'. 

### Architecture

![Lab02 Diagram](/lab02/images/Lab02-Architecture.png)

## Terraform Setup

### Config Files

Start off by creating the following files: 
* `main.tf`: This is where we will be provisioning our resources
* `variables.tf`: This file will contain all the input resources we decide to make
* `outputs.tf`: We will use this file to declare necessary outputs 
* `versions.tf`: We will use this to seperate out our required providers. 
* `terraform.tfvars`: This is where will will put the values to all our environment-agnostic variables.

The follow separation allows for the infrastructure logic to be kept distinct from its configuration. This break-down makes the codebase easier to review and is less intense to look at making it easier for other to navigate too. 

In this lab, since I will be doing this for both 'dev' and 'prod' environment; it would would make most sense to also create `custom.tfvars` file for each environment allowing up to assign values environment-specific input variables. 

Under the `/env` folder, I have created `dev.tfvars` and `prod.tfvars` for this purpose.

### Workspace

As I'm duing this lab with 1 subscription, I decided to create my two envirionment using different workspace to deliniate between the 'dev' and 'prod'. This will result in a statefile being created for each workspace, which is what we want for this lab. 

Show exsisting wokespaces (to see what we already have): 
```bash
terraform workspace list
```

Using the `default` workspace as my 'prod' workspace. I created a new one for dev through the follow command: 
```bash 
terraform workspace new dev
``` 
[!NOTE]
When a workspace is created, terraform automatically switches over that workspace.

### Providers 
For this lab, I am calling the `azurerm` provider to provision the cloud infrastructure as well as the `random` provider to create a unique integer for the storage account names. 

I include these in the `versions.tf` file using the following:
```hcl 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.57.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}

provider "azurerm" {
  features {}
}
```

## Infrastructure 

### Input Variables
In the `terraform.tfvars`, I set value for the following:
* Resource group name 
* Primary location 
* Storage account name

These were added to this file as they are applicable to both 'prod' and 'dev' environments and it would be redundanat to repeat these for each `custom.tfvars`. This gives both environments uniformity with regards to the naming conventions of their resource groups and storage account names. 

### Creating Resource Groups and Storage Accounts

This part was mainly navigating through the `azurerm` documentation on the terraform registry to underestand how the resources should be declared. 

Resource group: 
```hcl
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.group_name}-${var.env_name}"
  location = var.primary_location
}
```
Storage Account:
```hcl
resource "azurerm_storage_account" "sa_azure" {
  name                     = "${var.sa_backend_name}${random_integer.unq_id.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.primary_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```
Storage Container: 
```hcl
resource "azurerm_storage_container" "tf_state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.sa_azure.id
  container_access_type = "private"
}
```

These are declared within the `main.tf` file. 

### Environment Variable Inputs 

Now that all the configurations have been set, all that is left is to run `terraform apply`. However, as there would be one input variable missing the `-var-file` must be added followed by the `custom.tfvars` for each environment. 

```bash 
terraform apply -var-file /env/dev.tfvars
terraform apply -var-file /env/prod.tfvars
```
