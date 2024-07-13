
variable "location" {
  type = object({
    name  = string
    short = string
    mini  = string
  })
}

variable "env" {
  type        = string
  description = "The environment (related to a subscription) used to manage Azure resources."
}

variable "workload" {
  type = string
}

variable "azdo_project_name" {
  type = string
}

variable "agent_pools" {
  type = map(object({
    sku = optional(string, "Standard_B2ls_v2")
    instances = object({
      min           = number
      max           = number
      idle_time_min = number
    })
    spot_enabled = optional(bool, true)
    virtual_network = object({
      name                = string
      subnet_name         = string
      resource_group_name = string
    })
  }))
  default = {}
}

variable "repositories" {
  type = map(object({
    default_branch = optional(string, "refs/heads/main")
    files = optional(map(object({
      path                = string
      content             = string
      overwrite_on_create = optional(bool, true)
    })))
  }))
  default = {}
}

variable "pipelines" {
  type = map(object({
    path            = optional(string, "/")
    file_path       = string
    branch_name     = optional(string, "refs/heads/main")
    repository_name = string
    agent_pool_name = optional(string)
  }))
  default = {}
}