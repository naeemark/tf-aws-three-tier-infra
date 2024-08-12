output "instance_profile_name_backend" {
  description = "IAM instance profile name for backend"
  value       = aws_iam_instance_profile.backend_instance_profile.name
}

output "instance_profile_name_frontend" {
  description = "IAM instance profile name for frontend"
  value       = aws_iam_instance_profile.frontend_instance_profile.name
}