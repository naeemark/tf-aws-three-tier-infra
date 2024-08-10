output "tf_env" {
  description = "Infrastructure environemnt"
  value       = var.tf_env
}

output "alb_dns_uri" {
  description = "Application Load Balancer URI"
  value       = "http://${module.dev_infra.alb_dns}"
}
output "alb_dns_api_uri" {
  description = "Application Load Balancer URI"
  value       = "http://${module.dev_infra.alb_dns}/api/"
}

output "alb_dns_backend_uri" {
  description = "Application Load Balancer URI"
  value       = "http://${module.dev_infra.alb_dns}:8000"
}

# output "database_endpoint" {
#   description = "Databas connection endpoint"
#   value       = module.dev_infra.database_endpoint
# }

output "bastion_ips" {
  description = "public ip address for bastion"
  value       = module.dev_infra.bastion_ips
}

output "backend_ips" {
  description = "Backend IPs"
  value       = module.dev_infra.backend_ips
}

output "frontend_ips" {
  description = "Frontend IPs"
  value       = module.dev_infra.frontend_ips
}

