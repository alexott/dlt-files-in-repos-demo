resource "databricks_pipeline" "dlt_files_in_repos_demo" {
  name    = "${var.dlt_name_prefix} demo"
  library {
    notebook {
      path = "${databricks_repo.dlt_files_in_repos_in_prod.path}/pipelines/DLT-Pipeline.py"
    }
  }
  development = true
  cluster {
    num_workers = 1
    label       = "default"
  }
}

resource "databricks_pipeline" "dlt_files_in_repos_integration_test" {
  name    = "${var.dlt_name_prefix} Integration Test"
  library {
    notebook {
      path = "${databricks_repo.dlt_files_in_repos_in_staging.path}/tests/integration/DLT-Pipeline-Test.py"
    }
  }
  library {
    notebook {
      path = "${databricks_repo.dlt_files_in_repos_in_staging.path}/pipelines/DLT-Pipeline.py"
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
