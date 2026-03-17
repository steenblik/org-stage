# Palo Alto VMs and iLB go here

module "nva-template" {
  for_each        = local.nva_locality
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/compute-vm?ref=v52.0.0"
  project_id      = module.landing-project.project_id
  name            = "nva-template-${each.key}"
  zone            = "${each.value.region}-${each.value.zone}"
  instance_type   = "e2-standard-2"
  tags            = ["nva"]
  create_template = true
  can_ip_forward  = true
  network_interfaces = [
    {
      network = module.dmz-vpc.self_link
      subnetwork = try(
        module.dmz-vpc.subnet_self_links["${each.value.region}/dmz-default"], null
      )
      nat       = false
      addresses = null
    },
    {
      network = module.landing-vpc.self_link
      subnetwork = try(
        module.landing-vpc.subnet_self_links["${each.value.region}/landing-default"], null
      )
      nat       = false
      addresses = null
    }
  ]
  boot_disk = {
    initialize_params = {
      image = "projects/cos-cloud/global/images/family/cos-stable"
    }
  }
  options = {
    allow_stopping_for_update = true
    deletion_protection       = false
    spot                      = true
    termination_action        = "STOP"
  }
  metadata = {
    user-data = module.nva-cloud-config.cloud_config
  }
}

module "nva-mig" {
  for_each          = local.nva_locality
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/compute-mig?ref=v52.0.0"
  project_id        = module.landing-project.project_id
  location          = each.value.region
  name              = "nva-cos-${each.key}"
  instance_template = module.nva-template[each.key].template.self_link
  target_size       = 1
  auto_healing_policies = {
    initial_delay_sec = 30
  }
  health_check_config = {
    enable_logging = true
    tcp = {
      port = 22
    }
  }
}

module "ilb-nva-landing" {
  for_each = {
    for k, v in var.regions : k => {
      region    = v
      shortname = local.region_shortnames[v]
      subnet    = "${v}/landing-default-${local.region_shortnames[v]}"
    }
  }
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-lb-int?ref=v52.0.0"
  project_id    = module.landing-project.project_id
  region        = each.value.region
  name          = "nva-landing-${each.key}"
  service_label = var.prefix
  forwarding_rules_config = {
    "" = {
      global_access = true
    }
  }
  vpc_config = {
    network    = module.landing-vpc.self_link
    subnetwork = try(module.landing-vpc.subnet_self_links[each.value.subnet], null)
  }
  backends = [
    for k, v in module.nva-mig :
    { group = v.group_manager.instance_group }
    if startswith(k, each.key)
  ]
  health_check_config = {
    enable_logging = true
    tcp = {
      port = 22
    }
  }
}