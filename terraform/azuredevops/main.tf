terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.4.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.14.0"
    }
  }
}

# https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs

provider "azuredevops" {
  org_service_url       = var.devops_org_url
  personal_access_token = var.devops_pat
}

provider "databricks" {
}
