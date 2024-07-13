
resource "azuredevops_project" "project" {
  name               = var.name
  description        = var.description
  visibility         = var.visibility
  version_control    = var.version_control
  work_item_template = var.work_item_template

  features = var.features

  /**
  lifecycle {
    prevent_destroy = true
  }
  **/
}