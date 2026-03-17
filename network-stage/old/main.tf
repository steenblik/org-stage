/*
Terraform entire GCP network setup (All in us-west4)

- Trust VPC
- Untrust VPC

- 2x partner interconnect with vlan attachments
- 1x Cloud Router with BGP Session

- 2x Palo Alto NVA devices
    - each with 1 interface on the trust VPC with ILB
    - each with 1 interface on the untrust VPC
        - Untrust interfaces also have public IPs
    - All internet bound traffic must be routed through the Palo Alto devices via the ILB

---



1. Palo Alto NVAs, MIGs, and Templates
gcloud compute instance-templates list
gcloud compute instance-templates describe [TEMPLATE_NAME] --project=[PROJECT_ID] --format=json

gcloud compute instance-groups list
gcloud compute instance-groups unmanaged describe [MIG_NAME] --region=us-west4 --project=[PROJECT_ID] --format=json
gcloud compute instance-groups managed describe [MIG_NAME] --region=us-west4 --project=[PROJECT_ID] --format=json

gcloud compute instances list --zone=[ZONE] --project=[PROJECT_ID] --format=json
gcloud compute instances describe [INSTANCE_NAME] --zone=[ZONE] --project=[PROJECT_ID] --format=json

2. VPCs and Shared VPC Configuration
These commands confirm the routing mode (global vs. regional) and the Shared VPC host/service project relationships.

VPC Network Details:

gcloud compute networks list
gcloud compute networks describe [VPC_NAME] --project=[PROJECT_ID] --format=json

Shared VPC Host Status:

gcloud compute shared-vpc get-host-project [PROJECT_ID] --format=json

Service Projects (Run on Host Project):

gcloud compute shared-vpc associated-projects list [HOST_PROJECT_ID] --format=json

3. Partner Interconnect (VLAN Attachments)
Capture these to get the pairingKey and googleReferenceId if you are importing existing attachments.

VLAN Attachment Details:

gcloud compute interconnects attachments describe [ATTACHMENT_NAME] --region=us-west4 --project=[PROJECT_ID] --format=json

4. Cloud Router and BGP Sessions
The JSON output here will show the bgpPeers array, which maps directly to the bgp block in the CFF net-cloudrouter module.

Cloud Router Configuration:

gcloud compute routers describe [ROUTER_NAME] --region=us-west4 --project=[PROJECT_ID] --format=json

BGP Session Status & Learned Routes:

gcloud compute routers get-status [ROUTER_NAME] --region=us-west4 --project=[PROJECT_ID] --format=json


5. DNS
gcloud dns policies describe [POLICY_NAME] --project=[PROJECT_ID] --format=json
gcloud dns managed-zones describe [ZONE_NAME] --project=[PROJECT_ID] --format=json
gcloud compute addresses list --filter="purpose=DNS_RESOLVER" --project=[PROJECT_ID] --format=json
*/