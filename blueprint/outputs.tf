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

