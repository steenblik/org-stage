variable "billing" {
  description = "Billing related configurations."
  type = object({
    account_id            = string
    export_project_id     = string
    export_project_folder = optional(string)
  })
}

variable "organization" {
  description = "Organization related configurations."
  type = object({
    id           = string
    workspace_id = string
  })
}

variable "essential_contacts_email" {
  description = "Email address for essential contacts setup."
  type        = string
}

variable "automation" {
  description = "Automation (Terraform) related configurations."
  type = object({
    project_id         = string
    organization_tf_sa = string
  })
}

variable "locations" {
  description = "Locations for GCS, BigQuery, and logging buckets created here."
  type = object({
    bq      = optional(string, "US")
    gcs     = optional(string, "US")
    logging = optional(string, "global")
    pubsub  = optional(list(string), [])
  })
  nullable = false
  default  = {}
}