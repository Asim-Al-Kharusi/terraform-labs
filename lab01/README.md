# Lab 01 - Terraform fundamentals

This lab will go over the core concepts and fundamentals of terraform including the HCL syntax.

## Terraform Core Workflow 

The terraform core workflow is the lifecycle that users will use through their journey on using terraform. This lifecycle has 5 main stages. 

![Core Workflow Diagram](/lab01/images/terraform-workflow.png)

<details>
<summary>1. Initialisation </summary>
This step is the first thing that should be done in order to get started after having written a new configuration and will perform the following: 

* Initialise the working directory that contains the terraform config files.
* Download necessary providers and modules.
* Configures the backend.

This can be performed using the following terraform CLI command: 
``` bash
terraform init
``` 
</details>

<details>
<summary>2. Validation </summary>
This can be used to validate the terraform configuration, checking for syntax and logical errors. 

This can be performed using the following terraform CLI command: 
``` bash
terraform validate
``` 
</details>

<details>
<summary>3. Planning</summary>
At the stage where you are happy with your code and want to move onto applying. Using

``` bash
terraform plan 
``` 
is very useful as this will create an execution plan showing a preiview of the proposed changes without modifying the existing infrastructure, showing you what terraform will create, modify or delete. Terraform refers to the state file to show upcoming changes. 
</details>

<details>
<summary>4. Applying Changes </summary> 
This is where the magic happens. Using 

```bash 
terraform apply
```
will push changes updating the state file to the desired state. I think it is appropriate that we mention that this process is **idempotent** meaning that no matter how many times you hit apply, if the apply and the state file already matches then nothing will change. 
</details>

<details>
<summary>5. Destroy </summary>
As the name may suggest this part of the lifecycle is where we destroy our terraform managed infrastructure. 
This is done using the following terraform CLI command: 

``` bash
terraform destroy 
``` 
</details>

## Terraform State

Terraform state is how Terraform tracks the real-world infrastructure it manages. The state file (terraform.tfstate) maps resources defined in your configuration files to the actual resources that exist in the target platform (eg Azure, AWS, or GCP).

Terraform uses states to understand: 
* What resources exist
* How they are configured
* Changes made to reach desired state

[!WARNING]
Sensitive data is exposed in the terraform state file. 

### State Immutability and Backups
Terraform state is treated as immutable. This means:
* Terraform does not edit the state file directly.
* Each time terraform apply is run, Terraform:
    * Calculates the new desired state
    * Writes a new version of the state file
    * Overwrites the previous state file
    * Automatically creates a backup file (terraform.tfstate.backup) locally

This immutability ensures consistency and reduces the risk of partial or corrupted state. The backup allows recovery in case something goes wrong during an apply.

## Workspaces
Terraform workspaces allow you to manage multiple instances of state using the same config files. Each workspace has its own separate state file, enabling you to reuse infrastructure code across multiple environments.

In this lab, I created to following workspaces:
* dev
* test
* prod

### Creating and Managing Workspaces
Workspaces are managed using the Terraform CLI.

Create a new workspace: 
```bash
terraform workspace new dev
```
List exsisting workspaces: 
```bash
terraform workspace list 
```
Switch to a workspace: 
```bash
terraform workspace select prod 
```
Terraform automatically uses the state file associated with the currently selected workspace.

## Remote Backend
A remote backend is a backend configuration that stores the Terraform state file outside of the local filesystem, typically in a shared and secure location such as Azure Blob Storage. Although it is not implemented in this lab specifically, I think it is worth noting within this fundamental lab.

### Why Remote Backends Are Useful
Remote backends provide several key benefits:
* Single source of truth – All users and pipelines reference the same state file.
* Team collaboration – Multiple engineers can safely work on the same infrastructure.
* State locking – Prevents concurrent terraform apply operations that could corrupt state.
* Improved security – State files often contain sensitive data and should not live on individual machines.

### Multiple State Files For Each Environment
Remote backends make it easy to maintain separate state files per environment, such as:
* dev
* test
* prod

This can be achieved by:
* Using different backend configurations
* Using different state file keys
* Combining remote backends with workspaces

Each environment maintains its own isolated state while still using the same Terraform codebase. This pattern is considered best practice for real-world Terraform deployments.

## Variables
Variables can be used to define values within the terraform configuration files without hard coding making the files reusable, flexible and environment-agnostic.

Variables come in two type: 
* Input variables - these are variable which the user is expected to provide and can be done through different approaches. The syntax for this is as follows:
```hcl 
variable "variable_name"{
    #variable attributes
}
```
and can be reference in the code by using `var.variable_name`.

* Local variables - variable derived within the congiguration files themselves. Unlike the input variables, local variables are declared through the 'locals' block shown below and can be referenced through `local.my_variable`.

```hcl 
locals{
    my_variable = "hello, world"
}
```

<details>
<summary><strong>Variable Types </strong></summary>

**HashiCorp Configuration Language** (HCL) allows for the following variable types: 
* string: *text values*
* number: *numeric values of both integer and floats*
* bool: *boolean ie true/false value*

Variables can be collated in the collectiont types:
* list: *ordered collection of values of the same type*
* map: *collection of key-value pairs (dictionary)*
* set: *unordered collection of unique values*

Finally, multiple types can be stored in a singal structural type. There are two supported structural types: 
* object: a single value with named attributes
* tuple: an ordered set of values with specific types.
</details>

<details>
<summary><strong>Attributes</strong></summary>
Within the variable block, there are numerous attributes that can be assigned to a varible. I like to think of attributes as optional settings that can be defined when delcaring a variable. These can be things such as the variable type, default values, description, sensitive (for handle secrets), validations and etc. 

This is an example of the variable "application_name" I declared in variables.tf.

```hcl 
variable "application_name" {
  type = string

  validation {
    condition     = length(var.application_name) <= 12
    error_message = "Application name must be 12 characters or less."
  }
}
```
</details>

For input variables, the user is given different options as how they provide these with some approached taking precedence over others. 

| Input method | Precendence | Description |
|--------------|-------------|-------------|
| CLI (ie custom.tfvars)|    Highest  | CLI driven, this requires a CLI command with flag -var-file |
| *.auto.tfvars| Higher | The files are automatically loaded and can override exsisting variables of the same name|
| terraform.tfvars | Lower | Terraform will automatically pick up variables within this file. The file name name must be exactly 'terraform.tfvars' |
| Environment variables | Lowest | Envirionment variables can also be automatically picked up by terraform if the naming convention of the variable is set to TF_VAR_lower. |

The reason behind the precedence of each input type is due to the order in which terraform reads the data. This process starts with envrionment variables and end with manual CLI inputs. Values set to the same variable name through different approaches will override one another with the final value being the one terraform reads latest. 
![Input Precedence](/lab01/images/input-precedence.png)

## Outputs
Outputs in Terraform are used to expose values from your configuration after infrastructure has been created or updated. 

Outputs are commonly used to:
* Display important values after terraform apply
* Share data between modules
* Pass values to other tools or configurations

An output can be defined using the output block: 
```hcl 
output "application_name" {
  value = var.application_name
}
```
After applying the configuration, output values can be viewed using:
```bash 
terraform output
```
Outputs can also be marked as **sensitive** to prevent their values from being displayed in CLI output (for secrets management):
```hcl
output "api_key" {
  value     = var.api_key
  sensitive = true
}
```
Outputs provide a clean and controlled way to expose information from Terraform without needing to inspect the state file directly.

## Providers
Providers are responsible for interacting with external platforms and APIs. They allow Terraform to create, update, and delete resources on services such as Azure.

Each provider defines:
* The resources it supports
* The data sources it can query
* How Terraform communicates with the platform

Providers are declared in the `terraform` block. I have added the 'random' provider which I call in versions.tf as an example:
```hcl
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}
```
[!NOTE]
Notice that the name given the required provider must be written the exact same as in the source. 

Each time a provider in added, you must run `terraform init` as this will download the provider. 

## Modules
Modules are reusable collections of Terraform configuration files. Every Terraform configuration is technically a module, but modules are typically used to group related resources into logical, reusable components. 

Modules help with:
* Reusing infrastructure code
* Keeping configurations consistent across environments
* Improving readability 

Feel free to have a look at some of the module I called on `alpha`, `bravo` as well as some I created for this lab `regional-stamps`. 
