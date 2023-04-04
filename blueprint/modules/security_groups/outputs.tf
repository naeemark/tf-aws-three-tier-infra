output "frontend_sg_id" {
  description = "The ID of the frontend_sg"
  value       = aws_security_group.frontend_sg.id
}

output "alb_sg_id" {
  description = "The ID of the alb_sg"
  value       = aws_security_group.alb_sg.id
}
