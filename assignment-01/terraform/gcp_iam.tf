// Resource block to generate random id suffix
resource "random_id" "svcacc_suffix" {
  byte_length = 2
}

// Locals block to transform and construct values
locals {
  svcacc_roles = [
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
}

// Resource block to deploy Service Account
resource "google_service_account" "service_account" {
  display_name = var.service_account_name
  account_id   = "${var.service_account_name}-${random_id.svcacc_suffix.hex}"
  description  = "A service account to attach with compute engine instances of MIG."
}

// Resource block to provide access to service account
resource "google_project_iam_member" "service_account_iam" {
  for_each = toset(local.svcacc_roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
