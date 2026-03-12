terraform {
  cloud {
    organization = "gcpninja"
    workspaces {
      name = "org-stage"
    }
  }
}
provider "google" {
  project = "strategic-block-313515"
}
provider "google-beta" {
  project = "strategic-block-313515"
}