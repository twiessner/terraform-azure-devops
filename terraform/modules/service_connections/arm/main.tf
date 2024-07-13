
locals {
  cname = join("-", [var.azdo_project_name, var.env, var.workload])
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

resource "azurerm_user_assigned_identity" "uai" {
  name                = lower(join("-", ["id", local.cname]))
  location            = var.location.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "rbac" {
  for_each = var.rbac

  role_definition_name = each.key
  scope                = each.value
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}

resource "azuredevops_serviceendpoint_azurerm" "arm" {
  service_endpoint_name = lower(join("-", ["sc", local.cname]))
  description           = "Managed by Terraform"

  project_id                             = var.azdo_project_id
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"

  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.uai.client_id
  }

  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

resource "azurerm_federated_identity_credential" "fic" {
  name                = lower(join("-", ["fed-cred", local.cname]))
  resource_group_name = var.resource_group_name

  parent_id = azurerm_user_assigned_identity.uai.id
  audience  = ["api://AzureADTokenExchange"]
  issuer    = azuredevops_serviceendpoint_azurerm.arm.workload_identity_federation_issuer
  subject   = azuredevops_serviceendpoint_azurerm.arm.workload_identity_federation_subject
}