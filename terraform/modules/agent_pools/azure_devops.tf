
resource "azuredevops_elastic_pool" "elastic" {
  name       = lower(join("-", [var.workload, var.env, var.azdo_project_name]))
  project_id = var.azdo_project_id

  desired_idle         = var.instances.min
  max_capacity         = var.instances.max
  time_to_live_minutes = var.instances.idle_time_min

  service_endpoint_id    = module.sc.id
  service_endpoint_scope = module.sc.project_id
  azure_resource_id      = azurerm_linux_virtual_machine_scale_set.vmss.id

  depends_on = [
    module.sc
  ]
}