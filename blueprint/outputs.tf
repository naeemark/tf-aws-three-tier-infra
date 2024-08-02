output "alb_dns" {
  description = "exposes alb dns"
  value       = module.load_balancer.alb_dns
}

output "bastion_private_ip" {
  description = "private ip address for bastion"
  value       = module.bastion.bastion_private_ip
}

output "bastion_public_ip" {
  description = "public ip address for bastion"
  value       = module.bastion.bastion_public_ip
}

output "database_endpoint" {
  description = "Databas connection endpoint"
  value       = module.database.endpoint
}

output "private_ips" {
  description = "Backend Private IPs"
  value = module.backend.private_ips
}

output "public_ips" {
  description = "Backend Public IPs"
  value = module.backend.public_ips
}
