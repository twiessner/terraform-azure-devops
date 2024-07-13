
variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Managed by terraform."
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "version_control" {
  type    = string
  default = "Git"
}

variable "work_item_template" {
  type    = string
  default = "Agile"
}

variable "features" {
  type = map(string)
  default = {
    boards       = "enabled"
    pipelines    = "enabled"
    repositories = "enabled"
    testplans    = "disabled"
    artifacts    = "disabled"
  }
}