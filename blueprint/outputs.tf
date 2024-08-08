output "alb_dns" {
  description = "exposes alb dns"
  value       = module.load_balancer.alb_dns
}

# output "database_endpoint" {
#   description = "Databas connection endpoint"
#   value       = module.database.endpoint
# }

output "bastion_ips" {
  description = "Bastion IPs"
  value       = "Public: ${module.bastion.public_ip} - Private: ${module.bastion.private_ip}"
}

output "backend_ips" {
  description = "Backend IPs"
  value       = "Public: ${module.backend.public_ips} - Private: ${module.backend.private_ips}"
}

output "frontend_ips" {
  description = "Frontend IPs"
  value       = "Public: ${module.frontend.public_ips} - Private: ${module.frontend.private_ips}"
}
