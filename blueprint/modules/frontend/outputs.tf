data "aws_instances" "instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [var.asg_name]
  }
  depends_on = [aws_autoscaling_group.asg]
}

output "private_ips" {
  description = "private ip address"
  value       = length(data.aws_instances.instances.private_ips) > 0 ? join(", ", data.aws_instances.instances.private_ips) : "N/A"
}

output "public_ips" {
  description = "public ip address"
  value       = length(data.aws_instances.instances.public_ips) > 0 ? join(", ", data.aws_instances.instances.public_ips) : "N/A"
}