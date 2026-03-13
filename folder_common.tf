module "folder_hub" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder?ref=v52.0.0"

  parent = "organizations/${var.organization.id}"
  name   = "Common"
  #folder_create = false

  # Authoritative assignment for this role on this folder
  iam = {
    "roles/compute.networkAdmin" = ["group:network-admins@marvell.com"]
  }

  factories_config = {
    org_policies = "org_policies/folders/hub"
  }
}