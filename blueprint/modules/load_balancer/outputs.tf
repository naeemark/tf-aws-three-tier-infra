output "alb_target_group_arn" {
  description = "The ARN of the Load Balance Target Group"
  value       = aws_lb_target_group.tg.arn
}

output "alb_dns" {
  description = "exposes alb dns address"
  value       = aws_lb.alb.dns_name
}
