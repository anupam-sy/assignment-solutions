// Resource specific output definitions depends on the requirements
output "network_id" {
  value       = google_compute_network.vpc.id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "The URI of the VPC being created"
}

output "subnetwork_id" {
  value       = google_compute_subnetwork.subnet.id
  description = "The ID of the subnetwork being created"
}

output "subnetwork_self_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "The URI of the subnetwork being created"
}

output "service_account_email" {
  value       = google_service_account.service_account.email
  description = "The email of the service account being created"
}

output "instance_group_url" {
  value       = module.managed_instance_group.instance_group
  description = "Instance-group url of managed instance group"
}

output "dev_sql_instance_pwd" {
  description = "Random password for mysql instance."
  value       = random_string.mysql_instance_pwd.result
  sensitive   = true
}
