module "trust-vpc" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v52.0.0"
  project_id = var.network_project_id
  name       = "trust-vpc"
  mtu        = 1500
  dns_policy = {
    logging = var.dns.enable_logging
  }
  factories_config = {
    subnets_folder = "${var.factories_config.data_dir}/subnets/prod"
  }
  delete_default_routes_on_create = true
  psa_config                      = try(var.psa_ranges.prod, null)
  # Set explicit routes for googleapis; send everything else to NVAs
  create_googleapis_routes = {
    private    = true
    restricted = true
  }
  routes = {
    nva-primary-to-primary = {
      dest_range    = "0.0.0.0/0"
      priority      = 1000
      tags          = ["primary"]
      next_hop_type = "ilb"
      next_hop      = module.ilb-nva-landing["primary"].forwarding_rule_addresses[""]
    }
    nva-secondary-to-secondary = {
      dest_range    = "0.0.0.0/0"
      priority      = 1000
      tags          = ["secondary"]
      next_hop_type = "ilb"
      next_hop      = module.ilb-nva-landing["secondary"].forwarding_rule_addresses[""]
    }
    nva-primary-to-secondary = {
      dest_range    = "0.0.0.0/0"
      priority      = 1001
      tags          = ["primary"]
      next_hop_type = "ilb"
      next_hop      = module.ilb-nva-landing["secondary"].forwarding_rule_addresses[""]
    }
    nva-secondary-to-primary = {
      dest_range    = "0.0.0.0/0"
      priority      = 1001
      tags          = ["secondary"]
      next_hop_type = "ilb"
      next_hop      = module.ilb-nva-landing["primary"].forwarding_rule_addresses[""]
    }
  }
}