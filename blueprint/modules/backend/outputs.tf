output "private_ip" {
  description = "private ip address"
  value       = aws_instance.backend.private_ip
}

output "public_ip" {
  description = "public ip address"
  value       = aws_instance.backend.public_ip
}
