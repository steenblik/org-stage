variable "shared_vpc_host_project_id" {
  type = string
}

# This can go into
variable "project_config" {
  type = object({
    project_id = string
    services = optional(list(string), [
      "compute.googleapis.com"
    ])
  })
}
