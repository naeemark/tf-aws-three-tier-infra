variable "tf_env" {
  description = "The environment name abbrivation"
  type        = string
  default     = "prd"
}

variable "region" {
  type        = string
  default     = "ap-southeast-2"
  description = "Default AWS region where resources will be provisioned"
}

variable "env_ami_id" {
  type        = string
  default     = "ami-01371af0ade386e93"
  description = "AMI ID for the EC2 instance"
}
