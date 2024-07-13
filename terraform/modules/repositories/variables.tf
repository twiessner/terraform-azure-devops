
variable "azdo_project_id" {
  type = string
}

variable "workload" {
  type = string
}

variable "default_branch" {
  type = string
}

variable "files" {
  type = map(object({
    path                = string
    content             = string
    overwrite_on_create = bool
  }))
}