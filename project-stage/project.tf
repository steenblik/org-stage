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
          values = var.subnet_restriction
        }
      }]
    }
  }
}
