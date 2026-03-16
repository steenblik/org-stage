variable "shared_vpc_project_id" {
  type = string
}

variable "shared_vpc_name" {
  type = string
}

module "shared-vpc" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v52.0.0"
  project_id = var.shared_vpc_project_id
  name       = var.shared_vpc_name
  vpc_reuse = {
    use_data_source = true
  }
  /* To be done
  subnets = [
    for key, config in var.subnet_config : {
      # This subnet name is shared with the subnet name in the service-project org_policies block
      # if the name format is changed it must be changed there as well.
      name          = "${module.service-project.name}-${key}"
      region        = config.region
      ip_cidr_range = config.ip_cidr_range

      iam_bindings = {
        # Subnet restrictions are not guaranteed by this IAM policy because users/groups may have folder or organizaiton
        # permissions to compute.networkUser which would allow them access to any subnet.
        "${module.service-project.name}-${key}-iam" = {
          members = ["serviceAccount:service-${module.service-project.number}@compute-system.iam.gserviceaccount.com"]
          role    = "roles/compute.networkUser"
          subnet  = "${config.region}/${module.service-project.name}-${key}"
        }
      }
    }
  ]
  */
}
