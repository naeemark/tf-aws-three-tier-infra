variable "tags" {}
variable "ami_id" {}
variable "instance_type" {}
variable "public_subnet_id" {}
variable "security_group_ids" {}
variable "key_pair_name" {}
variable "user_data_script" {}
# variable "backend_private_ips" {}
# variable "backend_public_ips" {}
variable "required_bastion_setup" {}
variable "database_endpoint" {
  description = "Database connection endpoint"
  type        = string
  default     = "N/A"
}

