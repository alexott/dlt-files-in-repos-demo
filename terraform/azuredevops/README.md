This directory contains Terraform code to setup a DLT + Files in Repos demo project in the Azure DevOps.  To do that, you need to create a file `terraform.tfvars` with following variables:

* `devops_org_url`   - URL of your Azure DevOps instance, like, `https://dev.azure.com/company_name`.
* `devops_pat`       - Azure DevOps personal access token (PAT) obtained as described in [documentation](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/guides/authenticating_using_the_personal_access_token).  This PAT will be used to create a project in your Azure DevOps organization, and will be set inside Databricks workspace.
* `devops_user_name` - your user name inside Azure DevOps organization.

Also make sure that you configured authentication for the Databricks Terraform provider using one of the methods [described in the documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication) - see examples below.

And then execute `terraform apply` (use `terraform plan` to understand what changes will be made).

The code performs following actions:

* Creates a new project inside Azure DevOps organization.  Default name is `DLTFilesDemoProject` and could be changed by setting the `devops_project_name` variable.
* Creates a new Azure DevOps Git repository by cloning this demo.
* Set ups Git credential in Databricks workspace using provided Azure DevOps PAT.
* Creates 3 Databricks checkouts in the current user's folder with names `dlt-files-tf-dev`, `dlt-files-tf-staging`, and `dlt-files-tf-prod` to emulate transition between different stages.
* Creates a Databricks cluster that will be used to execute the tests in notebooks.
* Creates a temporary Databricks Personal Access Token (PAT) that will be used to authenticate to Databricks workspace from the build pipeline.
* Creates an Azure DevOps variable group that contains all parameters that are used by the build pipeline.
* Creates an Azure DevOps build pipeline using `azure-pipelines.yaml` file from the cloned repository.
* Creates an Azure DevOps release pipeline using `azure-pipelines-release.yaml` file from the cloned repository.

After code is executed, you will have fully configured repositories, build & release pipelines.


## Setting up the authentication

Databricks Terraform provider supports [multiple authentication methods](https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication) - personal access tokens (PAT), OAuth/AAD tokens (recommended), etc. On Azure, I personally recommend to use `azure-cli` authentication method that requires that you have Azure CLI installed and logged via `az login` - Databricks provider will need only specification of the Azure Databricks host, and then Azure CLI will be used to generate AAD tokens.  Another handy way of authentication - by providing a name of the profile in the Databricks CLI configuration file (`~/.databricks.cfg`).

The authentication parameters could be set either via environment variables (most flexible), or configured explicitly in the provider block.

### Using environment variables

Configuring authentication using the environment variables is very flexible method because you don't need to modify the source code.  Databricks provider documentation has a [table that maps provider's configuration parameters to environment variables names](https://registry.terraform.io/providers/databricks/databricks/latest/docs#environment-variables).  For example:

* If you use host + PAT for authentication, then you need to specify them as `DATABRICKS_HOST` & `DATABRICKS_TOKEN` correspondingly.
* If you already have authentication configured in the Databricks CLI config file, then you can specify profile name in the `DATABRICKS_CONFIG_PROFILE` environment variable.
* If you use Azure CLI authentication, then you need to provide only `DATABRICKS_HOST`.


### Explicitly configuring Databricks Terraform provider

If you want explicitly specify authentication parameters, then you need to modify the Databricks provider's block in the `main.tf`. Check provider's documentation for details of specific authentication method.  For example, if you use host + PAT, then you can configure the Databricks provider as following:

```
provider "databricks" {
  host  = "https://.....cloud.databricks.com"
  token = "dapi..."
}
```

But this method isn't very secure, because you can commit the token by mistake. It's better to provide sensitive parameters via variables.  Modify provider block as following:

```hcl
provider "databricks" {
  host  = var.databricks_workspace_url
  token = var.databricks_pat
}
```

Add declaration of variables:

```hcl
variable "databricks_workspace_url" {
  description = "Databricks URL"
  type        = string
}

variable "databricks_pat" {
  description = "Databricks PAT"
  type        = string
}
```

And specify parameters in the `terraform.tfvars` file:

```
databricks_workspace_url="https://.....cloud.databricks.com"
databricks_pat="dapi..."
```
