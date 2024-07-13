
variable "azdo_project_id" {
  type = string
}

variable "azdo_project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "workload" {
  type = string
}

variable "location" {
  type = object({
    name  = string
    short = string
    mini  = string
  })
}

variable "resource_group_name" {
  type = string
}

variable "spot_enabled" {
  type = bool
}

variable "sku" {
  type = string
}

variable "instances" {
  type = object({
    min           = number
    max           = number
    idle_time_min = number
  })
}

variable "virtual_network" {
  type = object({
    name                = string
    resource_group_name = string
    subnet_name         = string
  })
}