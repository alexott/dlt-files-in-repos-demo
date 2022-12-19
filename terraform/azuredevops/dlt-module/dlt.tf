resource "databricks_pipeline" "dlt_files_in_repos_demo" {
  name    = var.main_pipeline_name
  library {
    notebook {
      path = "${var.main_pipeline_repo_path}/pipelines/DLT-Pipeline.py"
    }
  }
  development = true
  cluster {
    num_workers = 1
    label       = "default"
  }
}

resource "databricks_pipeline" "dlt_files_in_repos_integration_test" {
  name    = var.test_pipeline_name
  library {
    notebook {
      path = "${var.test_pipeline_repo_path}/tests/integration/DLT-Pipeline-Test.py"
    }
  }
  library {
    notebook {
      path = "${var.test_pipeline_repo_path}/pipelines/DLT-Pipeline.py"
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
