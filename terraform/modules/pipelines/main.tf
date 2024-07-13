
data "azuredevops_git_repository" "repo" {
  name       = var.repository_name
  project_id = var.azdo_project_id
}

data "azuredevops_agent_queue" "pool" {
  count = var.agent_pool_name != null ? 1 : 0

  project_id = var.azdo_project_id
  # Convention over configuration
  name = lower(join("-", [var.agent_pool_name, var.env, var.azdo_project_name]))
}

resource "azuredevops_build_definition" "pipeline" {
  project_id = var.azdo_project_id

  name = var.workload
  path = replace(var.path, "/", "\\")

  ci_trigger {
    use_yaml = false
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repository.repo.id
    branch_name = var.branch_name
    yml_path    = var.file_path
  }
}

resource "azuredevops_pipeline_authorization" "auth" {
  count = var.agent_pool_name != null ? 1 : 0

  project_id  = var.azdo_project_id
  pipeline_id = azuredevops_build_definition.pipeline.id
  resource_id = data.azuredevops_agent_queue.pool[0].id
  type        = "queue"

  depends_on = [
    azuredevops_build_definition.pipeline
  ]
}
