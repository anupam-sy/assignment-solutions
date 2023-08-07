// Variables definition - Common
project_id = "prj-tf-training"
region     = "us-central1"
zone       = "us-central1-a"

// Variables definition - Network and Subnetwork
network = {
  name                            = "dev-vpc"
  routing_mode                    = "GLOBAL"
  auto_create_subnetworks         = "false"
  delete_default_routes_on_create = "false"
}

subnetwork = {
  name                     = "dev-vpc-subnet"
  ip_cidr_range            = "10.0.50.0/24"
  region                   = "us-central1"
  private_ip_google_access = "true"
}

iap_firewall_name = "dev-vpc-fw-allow-ingress-from-iap"
cloud_nat_name    = "dev-cloud-natgw"
cloud_router_name = "dev-cloud-router"

// Variables definition - Instance Templates
service_account_name = "dev-gce-service-account"
name_prefix          = "dev-instance-template"
machine_type         = "e2-medium"
tags                 = ["dev", "linux"]

source_image         = "debian-11-bullseye-v20230509"
source_image_family  = "debian-11"
source_image_project = "debian-cloud"

disk_size_gb = "50"
disk_type    = "pd-balanced"
auto_delete  = "true"

// Variables definition - Managed Instance Groups
mig_name                  = "dev-managed-instance-group"
hostname                  = "dev-migvm"
distribution_policy_zones = ["us-central1-a", "us-central1-b", "us-central1-c"]
target_size               = 6

autoscaling_enabled = "true"
autoscaler_name     = "dev-managed-instance-group-autoscaler"
autoscaling_mode    = "ON"
max_replicas        = 10
min_replicas        = 2
cooldown_period     = 120
autoscaling_cpu = [
  {
    target            = 0.6
    predictive_method = "NONE"
  }
]

health_check_name = "dev-managed-instance-group-healthcheck"
health_check = {
  type                = "http"
  initial_delay_sec   = 120
  check_interval_sec  = 30
  healthy_threshold   = 2
  timeout_sec         = 10
  unhealthy_threshold = 2
  response            = ""
  proxy_header        = "NONE"
  port                = 80
  request             = ""
  request_path        = "/"
  host                = ""
  enable_logging      = false
}

named_ports = [
  {
    name = "http",
    port = 80
  }
]
update_policy = [
  {
    max_surge_fixed              = 3
    instance_redistribution_type = "PROACTIVE" # If PROACTIVE (default), the group attempts to maintain an even distribution of VM instances across zones in the region. If NONE, proactive redistribution is disabled.
    max_surge_percent            = null
    max_unavailable_fixed        = 3
    max_unavailable_percent      = null
    min_ready_sec                = 50           # Time to wait between consecutive instance updates
    replacement_method           = "SUBSTITUTE" # If RECREATE, instance names are preserved. If SUBSTITUTE (default), the group replaces VM instances with new instances that have randomly generated names.
    minimal_action               = "REPLACE"    # Minimal action to be taken on an instance for update. If REPLACE, Updator will delete and create new instances from the target template.
    type                         = "PROACTIVE"  # The type of update process. If PROACTIVE, updator will proactively executes actions in order to bring instances to their target versions or If OPPORTUNISTIC, no action is proactively executed but the update will be performed as part of other actions (for example, resizes). 
  }
]

// Variables definition - Application Load Balancer (https)
lb_name               = "dev-http-lb"
load_balancing_scheme = "EXTERNAL_MANAGED"

firewall_networks = ["dev-vpc"]
firewall_projects = ["prj-tf-training"]
target_tags       = ["dev", "linux"]

managed_ssl_certificate_domains = ["dev.anupamyadav.in"]
random_certificate_suffix       = true

// Variables definition - Cloud SQL with MySQL engine
db_instance_name  = "dev-mysql-instance"
database_version  = "MYSQL_5_7"
availability_type = "REGIONAL"
secondary_zone    = "us-central1-b"
db_backup_region  = "us-east1"
