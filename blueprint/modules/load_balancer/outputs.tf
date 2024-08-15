output "alb_arn" {
  description = "The ARn of the load balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns" {
  description = "Exposes alb dns address"
  value       = aws_lb.alb.dns_name
}

output "frontend_alb_target_group_arn" {
  description = "The ARN of the Load Balance Target Group"
  value       = aws_lb_target_group.frontend_tg.arn
}

output "backend_alb_target_group_arn" {
  description = "The ARN of the Load Balance Target Group"
  value       = aws_lb_target_group.backend_tg.arn
}

# output "backend_alb_target_group_8000_arn" {
#   description = "The ARN of the Load Balance Target Group"
#   value       = aws_lb_target_group.backend_tg_8000.arn
# }