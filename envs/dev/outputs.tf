output "alb_dns_uri" {
  description = "Application Load Balancer URI"
  value       = "http://${module.dev_infra.alb_dns}"
}
output "bastion_public_ip" {
  description = "public ip address for bastion"
  value       = module.dev_infra.bastion_public_ip
}

