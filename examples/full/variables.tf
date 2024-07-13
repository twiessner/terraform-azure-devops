
variable "tenant_id" {
  type        = string
  description = "The id of the Azure tenant, used to manage resources."
}

variable "subscription_id" {
  type        = string
  description = "The id of the Azure subscription, used to manage resources."
}

variable "azure_devops_pat" {
  type        = string
  description = "The Azure devops personal access token (administrator permissions)."
}

variable "azure_devops_org_url" {
  type        = string
  description = "The Azure Devops organisation url used to manage Devops resources."
}

variable "azure_devops_project_name" {
  type        = string
  description = "The Azure Devops project name used to manage Devops resources."
}

variable "env" {
  type        = string
  description = "The environment (subscription key) used to manage Azure resources."
}

variable "workload" {
  type        = string
  description = "Used context to generate Azure resources names."
}

variable "location" {
  type = object({
    name  = string
    short = string
    mini  = string
  })
  description = "The Azure region, used to manage resources."
}

variable "agent_pools" {
  type = map(object({
    sku = string
    instances = object({
      min           = number
      max           = number
      idle_time_min = number
    })
    spot_enabled = bool
    virtual_network = object({
      name                = string
      subnet_name         = string
      resource_group_name = string
    })
  }))
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
    path            = optional(string)
    file_path       = string
    branch_name     = optional(string, "refs/heads/main")
    repository_name = string
    agent_pool_name = optional(string)
  }))
  default = {}
}