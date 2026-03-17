module "service-project" {
  source   = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v52.0.0"
  name     = var.project_config.project_id
  services = var.project_config.services
  project_reuse = {
    use_data_source = true
  }

  shared_vpc_service_config = {
    host_project = var.shared_vpc_host_project_id
  }

  org_policies = {
    "compute.restrictSharedVpcSubnetworks" = {
      rules = [{
        allow = {
          # These subnet names are is shared with the subnet name in the shared-vpc module
          # if the name format is changed it must be changed there as well.
          values = [
            for key, config in var.subnet_config :
            "projects/${var.shared_vpc_config.host_project_id}/regions/${config.region}/subnetworks/${var.project_config.project_id}-${key}"
          ]
        }
      }]
    }
  }
}
