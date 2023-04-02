resource "azuredevops_project" "project" {
  name            = var.devops_project_name
  description     = "Test Project for DLT Files in Repos demo"
  visibility      = "private"
  version_control = "Git"
}

resource "azuredevops_git_repository" "repository" {
  project_id = azuredevops_project.project.id
  name       = "DLTFilesInReposDemo"
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "https://github.com/alexott/dlt-files-in-repos-demo"
  }
}

resource "azuredevops_build_definition" "build" {
  project_id = azuredevops_project.project.id
  name       = "DLT Files In Repos Staging Test"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repository.id
    branch_name = azuredevops_git_repository.repository.default_branch
    yml_path    = "azure-pipelines.yml"
  }

  variable_groups = [azuredevops_variable_group.vg.id]
}

resource "azuredevops_build_definition" "release" {
  project_id = azuredevops_project.project.id
  name       = "DLT Files In Repos Production Release"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repository.id
    branch_name = "releases"
    yml_path    = "azure-pipelines-release.yml"
  }

  variable_groups = [azuredevops_variable_group.vg.id]
}



resource "databricks_token" "pat_for_devops" {
  comment          = "Azure DevOps DLT Files In Repos demo (10 days)"
  lifetime_seconds = 864000
}

resource "azuredevops_variable_group" "vg" {
  project_id   = azuredevops_project.project.id
  name         = "DLT Files In Repos Testing"
  description  = "Variable group for build job"
  allow_access = true

  variable {
    name  = "databricks_host"
    value = data.databricks_current_user.me.workspace_url
  }

  variable {
    name         = "databricks_token"
    secret_value = databricks_token.pat_for_devops.token_value
    is_secret    = true
  }

  variable {
    name  = "cluster_id"
    value = databricks_cluster.dlt_files_in_repos_testing.id
  }

  variable {
    name  = "staging_directory"
    value = databricks_repo.dlt_files_in_repos_in_staging.path
  }

  variable {
    name  = "production_directory"
    value = databricks_repo.dlt_files_in_repos_in_prod.path
  }

  variable {
    name  = "test_dlt_pipeline_id"
    value = module.dlt_prod.test_pipeline_id
  }

  variable {
    name  = "test_dlt_pipeline_name"
    value = module.dlt_prod.test_pipeline_name
  }

}
