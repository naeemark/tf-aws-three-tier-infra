variable "tf_env" {
  description = "The environemnt name abbrivation"
  type        = string
}

variable "region" {
  type        = string
  description = "AWS region where resources will be provisioned"
}

variable "profile" {
  type        = string
  description = "AWS profile configured in aws-cli"
  default = "muaksite"
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

# Database Service Port
variable "database_instance_port" {
  description = "RDS Database Server port"
  type        = number
  default     = 3306
}

# Execution Resources
variable "backend_ami_id" {
  description = "AMI ID for the backend EC2 instance"
  type        = string
  default     = "ami-07f19180600636c9c"
}

variable "backend_instance_type" {
  description = "Instance type for the backend EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "frontend_ami_id" {
  description = "AMI ID for the frontend EC2 instances"
  type        = string
  default     = "ami-07f19180600636c9c"
}

variable "frontend_instance_type" {
  description = "Instance type for the frontend EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "required_database_setup" {
  description = "Flag to control creation of the database instance"
  type        = bool
  default     = false
}

variable "required_bastion_setup" {
  description = "Flag to control creation of the bastion host"
  type        = bool
  default     = false
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion EC2 instance"
  type        = string
  default     = "ami-07f19180600636c9c"
  # default     = "ami-0809dd5035d9217b8" # base ami
}

variable "key_pair_name" {
  description = "Instance connection key pair name"
  type        = string
  default     = "itadmin-keypair-1"
}

variable "tags" {
  description = "Custom tags for the Project"
  type        = map(any)
  default = {
    Project = "bbeans"
    Owner   = "itadmin"
  }
}

