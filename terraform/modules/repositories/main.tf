
resource "azuredevops_git_repository" "repo" {
  project_id     = var.azdo_project_id
  name           = var.workload
  default_branch = var.default_branch

  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_git_repository_file" "file" {
  for_each = var.files

  repository_id = azuredevops_git_repository.repo.id
  branch        = azuredevops_git_repository.repo.default_branch

  file                = each.value.path
  content             = each.value.content
  overwrite_on_create = each.value.overwrite_on_create
  commit_message      = "Managed by terraform."
}