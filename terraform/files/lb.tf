resource "google_compute_forwarding_rule" "puma-forward" {
  name                  = "puma-forwarding-rule"
  target                = google_compute_target_pool.puma-pool.self_link
  port_range            = "9292"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_target_pool" "puma-pool" {
  name          = "puma-target-pool"
  instances     = google_compute_instance.app[*].self_link
  health_checks = ["${google_compute_http_health_check.puma-check.name}"]
}


resource "google_compute_http_health_check" "puma-check" {
  name                = "check-puma-instances"
  port                = 9292
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 5
  unhealthy_threshold = 5

}
