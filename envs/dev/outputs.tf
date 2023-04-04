output "alb_dns_uri" {
  description = "Application Load Balancer URI"
  value       = "http://${module.dev_infra.alb_dns}"
}
