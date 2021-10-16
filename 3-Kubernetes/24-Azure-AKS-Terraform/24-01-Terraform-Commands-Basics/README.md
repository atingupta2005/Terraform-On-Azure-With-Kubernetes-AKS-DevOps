# Terraform Command Basics

## Step-01: Introduction
- Install Terraform
- Understand what is Terraform
- Understand Terrafom basic / essential commands
  - terraform version
  - terraform init
  - terraform plan
  - terraform validate
  - terraform apply -auto-approve
  - terraform show
  - terraform refresh
  - terraform providers
  - terraform destroy -auto-approve


## Step-02: Terraform Install
- **Referene Link:**
- [Download Terraform](https://www.terraform.io/downloads.html)
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get -y update && sudo apt-get install -y terraform
```

## Step-03: Install Azure CLI
```
# AZ CLI Current Version (if installed)
az --version
```
```
# Azure CLI Login
az login
```
```
# List Subscriptions
az account list
```
```
# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

## Step-04: Understand terrafrom init & provider azurerm
- Understand about [Terraform Providers](https://www.terraform.io/docs/providers/index.html)
- Understand about [azurerm terraform provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs), version and features
- terraform init: Initialize a Terraform working directory
- terraform apply -auto-approve: Builds or changes infrastructure
```
# Change Directory to v1 folder
cd v1-terraform-azurerm-provider
```
```
# Initialize Terraform
terraform init
```
```
# Explore ".terraform" folder
tree .terraform
# review (.terraform/plugins/registry.terraform.io/hashicorp/azurerm/2.35.0/darwin_amd64)
```
```
# Execute terraform apply -auto-approve
terraform apply -auto-approve
```
```
ls -lrta
#discuss about "terraform.tfstate"
```
```
# Delete .terraform folder (Understand what happens)
rm -rf .terraform
```
```
terraform apply -auto-approve #(Should say could not load plugin)
#To fix execute "terraform init"
```
```
# Clean-Up V1 folder
rm terraform.tfstate
ls -lrta
```

## Step-04: Understand terraform plan, apply & Create Azure Resource Group
- Authenticate to Azure using Azure CLI `az login`
- Understand about `terraform plan`
- Understand about `terraform apply -auto-approve`
- Create Azure Resource Group using Terraform
- terraform init: Initialize a Terraform working directory
- terraform plan: Generate and show an execution plan
- terraform apply -auto-approve: Builds or changes infrastructure
```
# Change Directory to v2 folder
cd ../v2-terraform-azurerm-resource-group
```

```
# Initialize Terraform
terraform init
```

```
# Validate terraform templates
terraform validate
```

```
# Dry run to see what resources gets created
terraform plan
```
```
# Create Resource Group in Azure
terraform apply -auto-approve
```
- Verify if resource group created in Azure using Management Console


## Step-05: Make changes to Resource Group and Deploy
- Add tags to Resource Group as below
```
# Create a Azure Resource Group
resource "azurerm_resource_group" "aksdev" {
  name     = "aks-rg2-tf"
  location = "Central US"

# Add Tags
  tags = {
    "environment" = "k8sdev"
  }
}
```

- Run terraform plan and apply
```
# Dry run to see what resources gets created
terraform plan
```
```
# Create Resource Group in Azure
terraform apply -auto-approve
```

- Verify if resource group created in Azure using Management Console

## Step-06: Modify Resource Group Name and Understand what happens
- Change Resource Group name from `aks-rg2-tf` to `aks-rg2-tf2` in main.tf
```
# Understand what happens with this change
terraform plan
```

```
# Apply changes
terraform apply -auto-approve
```
- Verify if resource group with new name got re-created in Azure using Management Console


## Step-07: Understand terraform refresh in detail
- **terraform refresh:** Update local state file against real resources in cloud
- **Desired State:** Local Terraform Manifest (main.tf)
- **Current State:**  Real Resources present in your cloud
- **Command Order of Execution:** refresh, plan, make a decision, apply

### Step-07-01: Add a new tag to Resource Group using Azure Portal Management console
```
demotag: refreshtest
```

### Step-07-02: Execute terraform plan  
- You should observe no changes to local state file because plan does the comparison in memory
- no update to tfstate file locally about the change
```
# Execute Terraform plan
terraform plan
```
### Step-07-03: Execute terraform refresh
- You should see local state file updated with new demo tag
```
# Execute terraform refresh
ls -lrta
```
```
terraform refresh
diff terraform.tfstate.backup terraform.tfstate
```
### Step-07-04: Why you need to the execution in this order (refresh, plan, make a decision, apply) ?
- There are changes happened in your infra manually and not via terraform.
- Now decision to be made if you want those changes or not.
- **Choice-1:** If you dont want those changes proceed with terraform apply -auto-approve so manual changes will be removed.
- **Choice-2:** If you want those changes, refer terraform.tfstate file about changes and embed them in your terraform manifests (example: main.tf) and proceed with flow (referesh, plan, review execution plan and apply)

### Step-07-05: I picked choice-2, so i will update the tags in main.tf
- Update in main.tf
```
  tags = {
    "environment" = "k8sdev"
    "demotag"     = "refreshtest"
  }
```
### Step-07-06: Execute the commands to make our manual change official in terraform manifests and tfstate files perspective  
```
# Execute commands
ls -lrta
```
```
terraform refresh
```
```
diff terraform.tfstate.backup terraform.tfstate
```
```
terraform plan
```
```
terraform apply -auto-approve
```

## Step-08: Understand terraform show, providers
- **terraform show:** Inspect Terraform state or plan
- **terraform providers:** Prints a tree of the providers used in the configuration
```
# Terraform Show
terraform show
```
```
# Terraform Providers
terraform providers
```


## Step-09: Understand terraform destroy -auto-approve
- Understand about `terraform destroy -auto-approve`
```
# Delete newly created Resource Group in Azure
terraform destroy -auto-approve
```
```
# Delete State (Deleting for github repo case for course purpose)
rm -rf .terraform
```
```
rm -rf terraform.tfstate
```


## References
- [Main Azure Resource Manager Reference](https://www.terraform.io/docs/providers/azurerm/index.html)
- [Azure Get Started on Terraform](https://learn.hashicorp.com/collections/terraform/azure-get-started)
- [Terraform Resources and Modules](https://www.terraform.io/docs/configuration/index.html#resources-and-modules)
