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

## Variables
Variables can be used to define values within the terraform configuration files without hard coding making the files reusable, flexible and environment-agnostic.

Variables come in two type: 
* Input variables - these are variable which the user is expected to provide and can be done through different approaches. The syntax for this is as follows:
```hcl 
variable "variable_name"{
    #variable attributes
}
```
and can be reference in the code by using ```hcl var.variable_name ```.

* Local variables - variable derived within the congiguration files themselves. Unlike the input variables, local variables are declared through the 'locals' block shown below and can be referenced through ```hcl local.my_variable ```.

```hcl 
locals{
    my_variable = "hello, world"
}
```

<details>
<summary>Variable Types </summary>

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
<summary>Attributes</summary>
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

