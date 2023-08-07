// Resource block to generate random passwords for SQL Instance
resource "random_string" "mysql_instance_pwd" {
  length      = 32
  upper       = true
  min_upper   = 5
  lower       = true
  min_lower   = 5
  numeric     = true
  min_numeric = 5
  special     = true
  min_special = 5
}

// Resource block to deploy Cloud SQL with MYSQL engine
resource "google_sql_database_instance" "mysql_instance" {
  project             = var.project_id
  name                = var.db_instance_name
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection
  root_password       = random_string.mysql_instance_pwd.result

  settings {
    availability_type = var.availability_type
    location_preference {
      zone           = var.zone
      secondary_zone = var.secondary_zone
    }

    tier              = var.tier
    edition           = var.edition
    activation_policy = var.activation_policy

    disk_size             = var.db_disk_size
    disk_type             = var.db_disk_type
    disk_autoresize       = var.db_disk_autoresize
    disk_autoresize_limit = var.db_disk_autoresize_limit

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }

    backup_configuration {
      enabled    = true
      start_time = "22:00"
      location   = var.db_backup_region

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }

      binary_log_enabled             = true
      transaction_log_retention_days = 7
    }

    maintenance_window {
      day          = 1
      hour         = 20
      update_track = "stable" # Receive updates earlier (canary) or later (stable).
    }
  }

  depends_on = [
    google_service_networking_connection.ps_connection
  ]
}

// Resource block to deploy MySQL database
resource "google_sql_database" "mysql_db" {
  project = var.project_id

  name       = "dev-database"
  instance   = google_sql_database_instance.mysql_instance.name
  charset    = "utf8"
  collation  = "utf8_general_ci"
  depends_on = [google_sql_database_instance.mysql_instance]
}
