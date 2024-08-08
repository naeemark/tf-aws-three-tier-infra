variable "tags" {}
variable "vpc_cidr_block" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}
variable "anywhere_cidr_block" {
  description = "CIDR Block with wildcard access"
  type        = string
  default     = "0.0.0.0/0"
}
