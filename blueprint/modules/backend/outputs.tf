data "aws_instances" "instances" {
  instance_tags = {
    Name = "bbeans-backend"
  }
  # instance_state_names = ["running", "stopped"]
}

output "private_ips" {
  description = "Instance Private IPs"
  value = data.aws_instances.instances.private_ips
}

output "public_ips" {
  description = "Instance Public IPs"
  value = data.aws_instances.instances.public_ips
}