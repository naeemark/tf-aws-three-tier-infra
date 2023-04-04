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
