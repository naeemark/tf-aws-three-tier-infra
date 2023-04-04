output "bastion_private_ip" {
  description = "private ip address"
  value       = aws_instance.bastion.private_ip
}

output "bastion_public_ip" {
  description = "public ip address"
  value       = aws_instance.bastion.public_ip
}
