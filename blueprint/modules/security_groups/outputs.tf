output "alb_sg_id" {
  description = "The ID of the alb_sg"
  value       = aws_security_group.alb_sg.id
}

output "frontend_sg_id" {
  description = "The ID of the frontend_sg"
  value       = aws_security_group.frontend_sg.id
}

output "database_sg_id" {
  description = "The ID of the database_sg"
  value       = aws_security_group.database_sg.id
}

output "backend_sg_id" {
  description = "The ID of the backend_sg"
  value       = aws_security_group.backend_sg.id
}

output "bastion_sg_id" {
  description = "The ID of the bastion_sg"
  value       = length(aws_security_group.bastion_sg) > 0 ? aws_security_group.bastion_sg[0].id : ""
}
