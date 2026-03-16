shared_vpc_config = {
  host_project_id     = "network-hub-project"
  host_project_number = "12345678901"
  parent_folder_id    = "folders/1234567890"
}

subnet_config = {
  us-west2-subnet = {
    region        = "us-west2"
    ip_cidr_range = "192.168.0.0/24"
  }
  us-west4-subnet = {
    region        = "us-west4"
    ip_cidr_range = "192.168.1.0/24"
  }
}

project_config = {
  project_id = "new-project"
}