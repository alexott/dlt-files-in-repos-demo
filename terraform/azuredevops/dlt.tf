module "dlt_user" {
  source                  = "./dlt-module/"
  main_pipeline_name      = "${var.dlt_name_prefix} demo (${data.databricks_current_user.me.alphanumeric})"
  main_pipeline_repo_path = databricks_repo.dlt_files_in_repos_in_user_home.path
  test_pipeline_name      = "${var.dlt_name_prefix} Integration Test (${data.databricks_current_user.me.alphanumeric})"
  test_pipeline_repo_path = databricks_repo.dlt_files_in_repos_in_user_home.path
}

module "dlt_prod" {
  source                       = "./dlt-module/"
  main_pipeline_is_development = false
  main_pipeline_name           = "${var.dlt_name_prefix} demo (Production)"
  main_pipeline_repo_path      = databricks_repo.dlt_files_in_repos_in_prod.path
  test_pipeline_name           = "${var.dlt_name_prefix} Integration Test (Staging)"
  test_pipeline_repo_path      = databricks_repo.dlt_files_in_repos_in_staging.path
}

