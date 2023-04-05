variable "vpc_id" {}

variable "alb_sg_name" {
  type    = string
  default = "alb_sg"
}

variable "alb_sg_description" {
  type    = string
  default = "sg for application load balancer"
}

variable "frontend_sg_name" {
  type    = string
  default = "frontend_sg"
}

variable "frontend_sg_description" {
  type    = string
  default = "sg for frontend"
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
variable "bastion_sg_name" {
  type    = string
  default = "bastion-sg"
}

variable "bastion_sg_description" {
  type    = string
  default = "sg for bastion"
}
