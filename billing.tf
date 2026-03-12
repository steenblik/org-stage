# module "billing-export-project" {
#   source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v52.0.0"
#   billing_account = var.billing.account_id
#   name            = var.billing.export_project_id
#   parent = coalesce(
#     var.billing.export_project_folder, "organizations/${var.organization.id}"
#   )
#   contacts = (
#     var.essential_contacts_email == null
#     ? {}
#     : { var.essential_contacts_email = ["ALL"] }
#   )
#   iam = {
#     "roles/owner" = [local.organization_tf_sa_iam_email]
#   }
#   services = [
#     "cloudresourcemanager.googleapis.com",
#     "iam.googleapis.com",
#     "serviceusage.googleapis.com",
#     "bigquery.googleapis.com",
#     "bigquerydatatransfer.googleapis.com",
#     "storage.googleapis.com"
#   ]
# }

module "billing-export-dataset" {
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/bigquery-dataset?ref=v52.0.0"
  project_id    = "strategic-block-313515"
  id            = "bq_billing_export1"
  friendly_name = "Billing export"
  location      = var.locations.bq
}
