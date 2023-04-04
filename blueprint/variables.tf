variable "tf_env" {
  description = "The environemnts abbrivation"
  type        = string
}

variable "region" {
  type        = string
  description = "AWS region where resources will be provisioned"
}

# Network Resources
variable "availability_zones" {
  description = "Aailaibility zones in AWS region where resources will be provisioned"
  type        = list(any)
  default     = ["us-west-1a", "us-west-1c"]
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# Execution Resources
variable "backend_ami_id" {
  description = "AMI ID for the backend EC2 instance"
  type        = string
  default     = "ami-0b695b365bec60938"
}

variable "backend_instance_type" {
  description = "Instance type for the backend EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "frontend_ami_id" {
  description = "AMI ID for the frontend EC2 instances"
  type        = string
  default     = "ami-0b695b365bec60938"
}
variable "frontend_instance_type" {
  description = "Instance type for the frontend EC2 instances"
  type        = string
  default     = "t2.micro"
}

