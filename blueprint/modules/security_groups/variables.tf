variable "tags" {}
variable "vpc_id" {}

variable "alb_sg_name" {
  type    = string
  default = "alb_sg"
}

variable "alb_sg_description" {
  type    = string
  default = "sg for application load balancer"
}

variable "alb_sg_allow_http" {
  description = "Allow http access to alb sg"
  type        = bool
  default     = false
}

variable "frontend_sg_name" {
  type    = string
  default = "frontend_sg"
}

variable "frontend_sg_description" {
  type    = string
  default = "sg for frontend"
}

variable "frontend_sg_allow_ssh" {
  description = "Allow ssh access to frontend sg"
  type        = bool
  default     = false
}

variable "frontend_sg_inbound_cidr_blocks" {
  type        = list(string)
  description = "frontend sg inbound cidr block"
  default     = ["0.0.0.0/0"]
}

variable "database_sg_name" {
  type    = string
  default = "database_sg"
}

variable "database_sg_description" {
  type    = string
  default = "sg for database"
}

variable "database_instance_port" {
  description = "Should be provided from outside"
}

variable "backend_sg_name" {
  type    = string
  default = "backend_sg"
}

variable "backend_sg_description" {
  type    = string
  default = "sg for backend"
}

variable "backend_sg_allow_ssh" {
  description = "Allow ssh access to backend sg"
  type        = bool
  default     = false
}

variable "backend_sg_inbound_cidr_blocks" {
  type        = list(string)
  description = "backend sg inbound cidr block"
  default     = ["0.0.0.0/0"]
}

variable "bastion_sg_name" {
  type    = string
  default = "bastion-sg"
}

variable "bastion_sg_description" {
  type    = string
  default = "sg for bastion"
}

variable "bastion_sg_inbound_cidr_blocks" {
  type        = list(string)
  description = "sg inbound cidr block"
  default     = ["0.0.0.0/0"]
}

variable "required_bastion_setup" {}
