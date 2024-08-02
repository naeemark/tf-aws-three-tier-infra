variable "tf_env" {
  description = "The environment name abbrivation"
  type        = string
  default     = "dev"
}

variable "region" {
  type        = string
  default     = "ap-southeast-2"
  description = "Default AWS region where resources will be provisioned"
}
