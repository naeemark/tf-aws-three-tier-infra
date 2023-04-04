variable "tf_env" {
  description = "The environment name abbrivation"
  type        = string
  default     = "dev"
}

variable "region" {
  type        = string
  default     = "us-west-1"
  description = "Default AWS region where resources will be provisioned"
}
