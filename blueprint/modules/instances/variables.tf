variable "tf_env" {}
variable "tags" {}
variable "ami_id" {}
variable "instance_type" {}
variable "security_group_ids" {}
variable "private_subnet_ids" {}
variable "user_data_script" {}
variable "key_pair_name" {}
variable "alb_target_group_arns" {}

variable "asg_name_prefix" {
  description = "Autoscalling Group name"
  type        = string
}

variable "desired_asg_capacity" {
  description = "Autoscalling Group desired capacity"
  type        = number
  default     = 2
}

variable "max_asg_capacity" {
  description = "Autoscalling Group max capacity"
  type        = number
  default     = 2
}

variable "min_asg_capacity" {
  description = "Autoscalling Group min capacity."
  type        = number
  default     = 1
}