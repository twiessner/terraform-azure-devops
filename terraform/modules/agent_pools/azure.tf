
resource "random_string" "user_name" {
  length = 12

  lower   = true
  upper   = false
  special = false

  keepers = {
    location            = var.location.name
    environment         = var.env
    resource_group_name = var.resource_group_name
  }
}

resource "random_password" "user_pass" {
  length = 28

  lower   = true
  upper   = true
  special = false

  keepers = {
    user_name = random_string.user_name.result
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = join("-", ["vmss", lower(var.azdo_project_name), var.env, "agent", "pool"])
  resource_group_name = var.resource_group_name
  location            = var.location.name

  sku           = var.sku
  instances     = 0 # scaling managed by azure devops elastic pool
  overprovision = false
  upgrade_mode  = "Manual"

  priority        = var.spot_enabled ? "Spot" : null
  eviction_policy = var.spot_enabled ? "Deallocate" : null

  admin_username                  = random_string.user_name.result
  admin_password                  = random_password.user_pass.result
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadOnly"
  }

  network_interface {
    name    = "default"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = data.azurerm_subnet.snet.id
    }
  }

  tags = {
    location          = var.location.name
    environment       = var.env
    azdo_project_name = var.azdo_project_name
  }
}