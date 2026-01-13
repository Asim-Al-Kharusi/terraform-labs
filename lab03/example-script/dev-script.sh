# set subscription 
export ARM_SUBSCRIPTION_ID="my subscription id"

# set the application / envirionment
export TF_VAR_application_name="observability"
export TF_VAR_environment_name="dev"

# set the backend
export BACKEND_RESORUCE_GROUP="rg-terraform-state-dev"
export BACKEND_STORAGE_ACCOUNT="tfsa35973"
export BACKEND_STORAGE_CONTAINER="tfstate"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESORUCE_GROUP}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${BACKEND_STORAGE_CONTAINER}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $* #this allow me to pass in any command ie plan or apply

#remove local loaded state 
rm -rf .terraform 