
module "devops" {
  source = "../../terraform"

  env      = var.env
  location = var.location
  workload = var.workload

  azdo_project_name = var.azure_devops_project_name
  agent_pools       = var.agent_pools
  pipelines         = var.pipelines
  repositories      = var.repositories
}