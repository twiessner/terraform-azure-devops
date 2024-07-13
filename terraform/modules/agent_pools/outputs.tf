
output "id" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "user_name" {
  value = random_string.user_name.result
}

output "credentials" {
  value = {
    username = random_string.user_name.result
    password = random_password.user_pass.result
  }
  sensitive = true
}