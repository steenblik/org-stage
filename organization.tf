module "organization" {
  # Pin to a specific version
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/organization?ref=v52.0.0"
  organization_id = "organizations/${var.organization.id}"

  # Terraform IAM resources for GCP can be wholistically authoritative for the entire policy, authoritative for a specific role, or additive.
  # See the preamble on this page: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_organization_iam

  # 1. Grant everyone in Marvell the ability to see the organization and project list in the UI
  iam = {
    "roles/browser" = ["domain:marvell.com"]
  }
  # 2. Add Viewer role to principal *additively*
  #    This ensures existing roles for this group (or other users on this role) are preserved.
  #   iam_bindings_additive = {
  #     platform-group-viewer = {
  #       member = "group:gcp-viewers@marvell.com"
  #       role   = "roles/viewer"
  #     }
  #   }

  org_policies = merge(
    var.organization.workspace_id == null ? {} : {
      "iam.allowedPolicyMemberDomains" = {
        rules = [{
          allow = { values = [var.organization.workspace_id] }
        }]
      }
    }
  )

  # 4. Use YAML based files for org polices (The module calls this "Factories")
  factories_config = {
    org_policies = "org_policies/org_level"
  }

  iam_by_principals_additive = {
    (local.organization_tf_sa_iam_email) = [
      "roles/billing.admin",
      "roles/iam.organizationRoleAdmin",
      "roles/orgpolicy.policyAdmin",
      ## From here down should probably be authoratitive
      "roles/essentialcontacts.admin",
      "roles/iam.workforcePoolAdmin",
      "roles/logging.admin",
      "roles/resourcemanager.organizationAdmin",
      "roles/resourcemanager.projectCreator",
      "roles/resourcemanager.projectMover",
      "roles/resourcemanager.tagAdmin"
    ]
  }
}
