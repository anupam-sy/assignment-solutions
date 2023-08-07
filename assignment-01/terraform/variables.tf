// Variables declaration - Common
variable "project_id" {
  type        = string
  description = "The ID of the google project to house the resources."
}

variable "region" {
  type        = string
  description = "The default region to create the google cloud regional resources."
}

variable "zone" {
  type        = string
  description = "The default zone to create the google cloud regional resources."
}

// Variables declaration - Network and Subnetwork
variable "network" {
  description = "The map of the network details being created"
  type        = map(string)
}

variable "subnetwork" {
  description = "The map of the subnetwork details being created"
  type        = map(string)
}

variable "iap_firewall_name" {
  description = "The name of the firewall to allow ssh access to instances from IAP"
  type        = string
}

variable "cloud_nat_name" {
  description = "The name of the Cloud NAT being created"
  type        = string
}

variable "cloud_router_name" {
  description = "The name of the Cloud Router being created for Cloud NAT"
  type        = string
}

// Variables declaration - Instance Templates
variable "service_account_name" {
  type        = string
  description = "The name of the service account to be attached with compute engine resources."
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  type        = string
  default     = "cust"
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n1-standard-1"
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

/* image */
variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = "centos-7"
}

variable "source_image_project" {
  description = "Project where the source image comes from. The default project contains CentOS images. It is required."
  type        = string
  default     = "centos-cloud"
}

/* disks */
variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = string
  default     = "100"
}

variable "disk_type" {
  description = "Boot disk type, can be either pd-ssd, local-ssd, or pd-standard"
  type        = string
  default     = "pd-standard"
}

variable "auto_delete" {
  description = "Whether or not the boot disk should be auto-deleted"
  type        = string
  default     = "true"
}

variable "additional_disks" {
  description = "List of maps of additional disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#disk_name"
  type = list(object({
    disk_name    = string
    device_name  = string
    auto_delete  = bool
    boot         = bool
    disk_size_gb = number
    disk_type    = string
    disk_labels  = map(string)
  }))
  default = []
}

// Variables declaration - Managed Instance Groups
variable "mig_name" {
  type        = string
  description = "Managed instance group name. When variable is empty, name will be derived from var.hostname."
  default     = ""
}

variable "hostname" {
  description = "The base instance name to use for instances in this group."
  type        = string
  default     = "default"
}

variable "distribution_policy_zones" {
  description = "The distribution policy, i.e. which zone(s) should instances be create in. Default is all zones in given region."
  type        = list(string)
  default     = []
}

variable "target_size" {
  description = "The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
  type        = number
  default     = 1
}

/* autoscaler */
variable "autoscaling_enabled" {
  description = "Creates an autoscaler for the managed instance group"
  default     = "false"
  type        = string
}

variable "autoscaler_name" {
  type        = string
  description = "Autoscaler name. When variable is empty, name will be derived from var.hostname."
  default     = ""
}

variable "autoscaling_mode" {
  description = "Operating mode of the autoscaling policy. If omitted, the default value is ON. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_autoscaler#mode"
  type        = string
  default     = null
}

variable "max_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  default     = 10
  type        = number
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0."
  default     = 2
  type        = number
}

variable "cooldown_period" {
  # The initialization period (previously 'cool down period') specifies how long it takes for your app to initialize from boot time until it is ready to serve.
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  default     = 60
  type        = number
}

variable "autoscaling_cpu" {
  description = "Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization"
  type = list(object({
    target            = number
    predictive_method = string
  }))
  default = []
}

/* health check */
variable "health_check_name" {
  type        = string
  description = "Health check name. When variable is empty, name will be derived from var.hostname."
  default     = ""
}

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    type                = string
    initial_delay_sec   = number
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    request             = string
    request_path        = string
    host                = string
    enable_logging      = bool
  })
  default = {
    type                = ""
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = ""
    enable_logging      = false
  }
}

/* port mapping and update policy */
variable "named_ports" {
  description = "Named name and named port"
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

variable "update_policy" {
  description = "The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy"
  type = list(object({
    max_surge_fixed              = number
    instance_redistribution_type = string
    max_surge_percent            = number
    max_unavailable_fixed        = number
    max_unavailable_percent      = number
    min_ready_sec                = number
    replacement_method           = string
    minimal_action               = string
    type                         = string
  }))
  default = []
}

// Variables declaration - Application Load Balancer (https)
variable "lb_name" {
  description = "Name for the forwarding rule and prefix for supporting resources"
  type        = string
}

variable "load_balancing_scheme" {
  description = "Load balancing scheme type (EXTERNAL for classic external load balancer, EXTERNAL_MANAGED for Envoy-based load balancer, and INTERNAL_SELF_MANAGED for traffic director)"
  type        = string
  default     = "EXTERNAL"
}

variable "firewall_networks" {
  description = "Names of the networks to create firewall rules in"
  type        = list(string)
  default     = []
}

variable "firewall_projects" {
  description = "Names of the projects to create firewall rules in"
  type        = list(string)
  default     = []
}

variable "target_tags" {
  description = "List of target tags for health check firewall rule. Exactly one of target_tags or target_service_accounts should be specified."
  type        = list(string)
  default     = []
}

variable "http_forward" {
  description = "Set to `false` to disable HTTP port 80 forward"
  type        = bool
  default     = true
}

variable "create_address" {
  type        = bool
  description = "Create a new global IPv4 address"
  default     = true
}

variable "https_redirect" {
  description = "Set to `true` to enable https redirect on the lb."
  type        = bool
  default     = true
}

variable "create_url_map" {
  description = "Set to `false` if url_map variable is provided."
  type        = bool
  default     = true
}

/* ssl configuration */
variable "ssl" {
  description = "Set to `true` to enable SSL support, requires variable `ssl_certificates` - a list of self_link certs"
  type        = bool
  default     = true
}

# Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`.
variable "random_certificate_suffix" {
  description = "Bool to enable/disable random certificate name generation. Set and keep this to true if you need to change the SSL cert."
  type        = bool
  default     = true
}

variable "managed_ssl_certificate_domains" {
  description = "Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` and `use_ssl_certificates` set to `false`."
  type        = list(string)
  default     = []
}

// Variables declaration - Cloud SQL with MySQL engine
variable "db_instance_name" {
  type        = string
  description = "The name of the Cloud SQL insatnce"
}

variable "database_version" {
  type        = string
  description = "The database version to use to deploy Cloud SQL insatnce"
}

variable "deletion_protection" {
  description = "Enables protection of an instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "availability_type" {
  description = "The availability type for the master instance. Can be either `REGIONAL` or `ZONAL`. Defaults to ZONAL, use null for defaults."
  type        = string
  default     = "REGIONAL"
}

variable "secondary_zone" {
  type        = string
  description = "The preferred zone for the secondary/failover instance"
}

variable "tier" {
  description = <<EOF
    The tier for the master instance. 
    For custom machine type -> db-custom-{NUMBER_OF_CPUS}-{MEMORY_IN_MIB} | Ex: 1 CPU, 4GB (=4*1024=4096MiB) ram -> db-custom-1-4096
  EOF
  type        = string
  default     = "db-n1-standard-1"
}

variable "edition" {
  description = "The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS"
  type        = string
  default     = "ENTERPRISE"
}

variable "activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "db_disk_size" {
  description = "The disk size for the master instance"
  type        = number
  default     = 10
}

variable "db_disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD_SSD"
}

variable "db_disk_autoresize" {
  description = "Configuration to increase storage size"
  type        = bool
  default     = true
}

variable "db_disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased. The default value is 0, which specifies that there is no limit."
  type        = number
  default     = 0
}

variable "db_backup_region" {
  type        = string
  description = "The region to store backups of databases."
}
