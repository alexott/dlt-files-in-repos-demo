output "test_pipeline_name" {
  value = var.test_pipeline_name
}

output "test_pipeline_id" {
  value = databricks_pipeline.dlt_files_in_repos_integration_test.id
}
