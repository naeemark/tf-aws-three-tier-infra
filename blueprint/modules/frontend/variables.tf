variable "ami_id" {}
variable "instance_type" {}
variable "security_group_ids" {}
variable "alb_target_group_arns" {}
variable "private_subnet_ids" {}
variable "user_data_script" {}
variable "asg_capacity" {
  description = "Autoscalling Group Capacity. (Sets a default value as per the requirements)"
  type        = number
  default     = 2
}
