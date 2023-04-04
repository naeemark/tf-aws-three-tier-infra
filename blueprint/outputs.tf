output "alb_dns" {
  description = "exposes alb dns"
  value       = module.load_balancer.alb_dns
}
