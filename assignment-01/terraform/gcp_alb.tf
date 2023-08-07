// Module block to deploy http load balancer
module "http_load_balancer" {
  source = "terraform-google-modules/lb-http/google"

  project               = var.project_id
  name                  = var.lb_name
  load_balancing_scheme = var.load_balancing_scheme

  http_forward   = var.http_forward
  create_address = var.create_address
  https_redirect = var.https_redirect
  create_url_map = var.create_url_map

  /* health check firewall rule */
  firewall_networks = var.firewall_networks
  firewall_projects = var.firewall_projects
  target_tags       = var.target_tags

  /* ssl configuration for google-managed certificate */
  ssl                             = var.ssl
  managed_ssl_certificate_domains = var.managed_ssl_certificate_domains
  random_certificate_suffix       = var.random_certificate_suffix

  backends = {
    default = {
      description = "Default Backend"
      protocol    = "HTTP"
      port_name   = "http"
      timeout_sec = 10 # Time to wait for the backend before considering it a failed request.
      port        = 80

      groups = [
        {
          group                        = module.managed_instance_group.instance_group
          balancing_mode               = "UTILIZATION"
          capacity_scaler              = 1
          description                  = ""
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = 0.8
        },
      ]

      /* cloud cdn configuration options */
      enable_cdn       = false
      compression_mode = "DISABLED"

      /* health check configuration */
      health_check = {
        check_interval_sec  = 5
        timeout_sec         = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        request_path        = "/"
        port                = 80
        host                = null
        logging             = false
      }

      /* logging for the load balancer traffic served by this backend service */
      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      /* cloud armor backend security policy and edge security policy */
      security_policy      = null
      edge_security_policy = null

      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      connection_draining_timeout_sec = 300 # Time given to the removed VM or endpoint to complete the exisitng requests. defaults to 300.

      /* custom headers */
      custom_request_headers  = []
      custom_response_headers = []

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
    }
  }
}
