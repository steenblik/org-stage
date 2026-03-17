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

variable "subnet_restriction" {
  description = "Set an org policy to restrict access to subnet if variable is set."
  type        = list(string)
  default = [
    "projects/excellent-zoo-464112-f6/regions/us-west4/subnetworks/alloydb-net"
  ]
}