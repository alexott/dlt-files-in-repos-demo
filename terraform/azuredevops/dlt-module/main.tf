terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
    }
  }
}


variable "main_pipeline_name" {
  type = string
  description = "Name of the main DLT pipeline"
}

variable "main_pipeline_repo_path" {
  type = string
  description = "Path to repo with main DLT pipeline"
}

variable "test_pipeline_name" {
  type = string
  description = "Name of the integration test DLT pipeline"
}

variable "test_pipeline_repo_path" {
  type = string
  description = "Path to repo with integration test DLT pipeline"
}

output "test_pipeline_name" {
  value = var.test_pipeline_name
}

output "test_pipeline_id" {
  value = databricks_pipeline.dlt_files_in_repos_integration_test.id
}
