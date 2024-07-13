
data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network.name
  resource_group_name = var.virtual_network.resource_group_name
}

data "azurerm_subnet" "snet" {
  name                 = var.virtual_network.subnet_name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

module "sc" {
  source = "../service_connections/arm"

  env      = var.env
  location = var.location
  workload = var.workload

  vmss_id             = azurerm_linux_virtual_machine_scale_set.vmss.id
  resource_group_name = var.resource_group_name

  azdo_project_id   = var.azdo_project_id
  azdo_project_name = var.azdo_project_name

  rbac = {
    "Virtual Machine Contributor" = azurerm_linux_virtual_machine_scale_set.vmss.id
  }

  depends_on = [
    azurerm_linux_virtual_machine_scale_set.vmss
  ]
}