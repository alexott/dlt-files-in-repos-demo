variable "main_pipeline_name" {
  type        = string
  description = "Name of the main DLT pipeline"
}

variable "main_pipeline_repo_path" {
  type        = string
  description = "Path to repo with main DLT pipeline"
}

variable "main_pipeline_is_development" {
  type        = bool
  description = "Set to false if production pipeline should run in Development mode"
  default     = false
}

variable "test_pipeline_name" {
  type        = string
  description = "Name of the integration test DLT pipeline"
}

variable "test_pipeline_repo_path" {
  type        = string
  description = "Path to repo with integration test DLT pipeline"
}

variable "main_notebooks" {
  type        = list(string)
  description = "List of strings representing notebooks paths for production code (relative to the repo root)"
}

variable "test_notebooks" {
  type        = list(string)
  description = "List of strings representing notebooks paths for tests (relative to the repo root)"
}
