resource "databricks_pipeline" "dlt_files_in_repos_demo" {
  name = var.main_pipeline_name
  dynamic "library" {
    for_each = toset(var.main_notebooks)
    content {
      notebook {
        path = "${var.main_pipeline_repo_path}/${library.value}"
      }
    }
  }

  development = var.main_pipeline_is_development
  cluster {
    num_workers = 1
    label       = "default"
  }
}

resource "databricks_pipeline" "dlt_files_in_repos_integration_test" {
  name = var.test_pipeline_name
  dynamic "library" {
    for_each = toset(concat(var.main_notebooks, var.test_notebooks))
    content {
      notebook {
        path = "${var.test_pipeline_repo_path}/${library.value}"
      }
    }
  }
  development = true
  configuration = {
    "my_etl.data_path" = "/databricks-datasets/wikipedia-datasets/data-001/clickstream/raw-uncompressed-json/2015_2_clickstream.json"
  }
  cluster {
    num_workers = 1
    label       = "default"
  }
}
