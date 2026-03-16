variable "shared_vpc_config" {
  type = object({
    host_project_id     = string
    host_project_number = string
    parent_folder_id    = string
  })
}

variable "project_config" {
  type = object({
    project_id = string
    services = optional(list(string), [
      "compute.googleapis.com"
    ])
  })
}

variable "subnet_config" {
  type = map(object({
    region        = string
    ip_cidr_range = string
  }))
}