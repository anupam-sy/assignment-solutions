// Data block to render a local file
data "local_file" "instance_template_startup_script" {
  filename = "${path.module}/scripts/install_nginx.sh"
}

// Module block to deploy instance template
module "instance_template" {
  source = "terraform-google-modules/vm/google//modules/instance_template"

  project_id     = var.project_id
  name_prefix    = var.name_prefix
  machine_type   = var.machine_type
  tags           = var.tags
  labels         = var.labels
  startup_script = data.local_file.instance_template_startup_script.content
  metadata       = var.metadata
  service_account = {
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }

  /* network */
  network            = google_compute_network.vpc.self_link
  subnetwork         = google_compute_subnetwork.subnet.self_link
  subnetwork_project = var.project_id

  /* image */
  source_image         = var.source_image
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project

  /* disks */
  disk_size_gb     = var.disk_size_gb
  disk_type        = var.disk_type
  auto_delete      = var.auto_delete
  additional_disks = var.additional_disks
}

// Module block to deploy managed instance group
module "managed_instance_group" {
  source = "terraform-google-modules/vm/google//modules/mig"

  project_id                = var.project_id
  mig_name                  = var.mig_name
  hostname                  = var.hostname
  instance_template         = module.instance_template.self_link
  region                    = var.region
  distribution_policy_zones = var.distribution_policy_zones
  target_size               = var.target_size

  /* autoscaler */
  autoscaling_enabled = var.autoscaling_enabled
  autoscaler_name     = var.autoscaler_name
  autoscaling_mode    = var.autoscaling_mode
  max_replicas        = var.max_replicas
  min_replicas        = var.min_replicas
  cooldown_period     = var.cooldown_period
  autoscaling_cpu     = var.autoscaling_cpu

  /* health check */
  health_check_name = var.health_check_name
  health_check      = var.health_check

  /* port mapping and update policy */
  named_ports   = var.named_ports
  update_policy = var.update_policy
}
