
variable "azdo_project_id" {
  type = string
}

variable "azdo_project_name" {
  type = string
}

variable "workload" {
  type = string
}

variable "env" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vmss_id" {
  type = string
}

variable "rbac" {
  type        = map(string)
  description = "Defines a map of 'role_name' to a scope (e.g. resource id)."
  default     = {}
}

variable "location" {
  type = object({
    name  = string
    short = string
    mini  = string
  })
}