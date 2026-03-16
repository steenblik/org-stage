#
#
#
#
resource "google_compute_router" "interconnect-router" {
  name    = "interconnect-router"
  network = "mynet"
  project = "myproject"
  region  = "europe-west8"
  # On-prem Palos are the BGP peer. They will share routes with MED values to send storage traffic to storage interconnect
  bgp {
    advertise_mode    = "CUSTOM"
    asn               = 64514
    advertised_groups = ["ALL_SUBNETS"]
    advertised_ip_ranges {
      range = "10.255.255.0/24"
    }
    advertised_ip_ranges {
      range = "192.168.255.0/24"
    }
  }
}

module "general-vlan-attachment" {
  source      = "./fabric/modules/net-vlan-attachment"
  network     = "mynet"
  project_id  = "myproject"
  region      = "europe-west8"
  name        = "vlan-attachment"
  description = "Example vlan attachment"
  peer_asn    = "65000"
  router_config = {
    create = false
    name   = google_compute_router.interconnect-router.name
  }
  dedicated_interconnect_config = {
    # cloud router gets 169.254.0.1 peer router gets 169.254.0.2
    bandwidth    = "BPS_10G"
    bgp_range    = "169.254.0.0/29"
    interconnect = "https://www.googleapis.com/compute/v1/projects/my-project/global/interconnects/interconnect-a"
    vlan_tag     = 12345
  }
}

module "storage-vlan-attachment" {
  source      = "./fabric/modules/net-vlan-attachment"
  network     = "mynet"
  project_id  = "myproject"
  region      = "europe-west8"
  name        = "vlan-attachment"
  description = "Example vlan attachment"
  peer_asn    = "65000"
  router_config = {
    create = false
    name   = google_compute_router.interconnect-router.name
  }
  dedicated_interconnect_config = {
    # cloud router gets 169.254.0.1 peer router gets 169.254.0.2
    bandwidth    = "BPS_10G"
    bgp_range    = "169.254.0.0/29"
    interconnect = "https://www.googleapis.com/compute/v1/projects/my-project/global/interconnects/interconnect-a"
    vlan_tag     = 12345
  }
}