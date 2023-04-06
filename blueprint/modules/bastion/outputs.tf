output "bastion_private_ip" {
  description = "private ip address"
  value       = length(aws_instance.bastion) > 0 ? aws_instance.bastion[0].private_ip : "N/A"
}

output "bastion_public_ip" {
  description = "public ip address"
  value       = length(aws_instance.bastion) > 0 ? aws_instance.bastion[0].public_ip : "N/A"
}
