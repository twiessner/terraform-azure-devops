
module "azdo_project" {
  source = "./modules/project"

  name = var.azdo_project_name
}

resource "azurerm_resource_group" "scope" {
  name     = join("-", ["rg", "devops", var.workload, var.location.mini])
  location = var.location.name

  tags = {
    environment = var.env
    scope       = "pipeline-agents"
    location    = var.location.name
  }
}

module "agent_pools" {
  source   = "./modules/agent_pools"
  for_each = var.agent_pools

  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.scope.name

  sku             = each.value.sku
  workload        = each.key
  instances       = each.value.instances
  spot_enabled    = each.value.spot_enabled
  virtual_network = each.value.virtual_network

  azdo_project_id   = module.azdo_project.id
  azdo_project_name = module.azdo_project.name
}

module "repositories" {
  source   = "./modules/repositories"
  for_each = var.repositories

  azdo_project_id = module.azdo_project.id
  workload        = each.key

  files          = each.value.files
  default_branch = each.value.default_branch

  depends_on = [
    module.azdo_project
  ]
}

module "pipelines" {
  source   = "./modules/pipelines"
  for_each = var.pipelines

  env      = var.env
  workload = each.key

  path            = each.value.path
  file_path       = each.value.file_path
  branch_name     = each.value.branch_name
  repository_name = each.value.repository_name
  agent_pool_name = each.value.agent_pool_name

  azdo_project_id   = module.azdo_project.id
  azdo_project_name = module.azdo_project.name

  depends_on = [
    module.agent_pools,
    module.repositories
  ]
}