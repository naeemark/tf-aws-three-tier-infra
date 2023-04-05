
variable "private_subnet_ids" {}
variable "security_group_ids" {}

# Default Configuration for database, should be provisioned
variable "instance_class" {
  description = "Databas instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "storage_allocation" {
  description = "Databas allocated storage in GBs"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Databas storage type"
  type        = string
  default     = "standard"
}

variable "db_engine" {
  description = "Databas Engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Databas Engine Version"
  type        = number
  default     = 12
}

variable "db_name" {
  description = "Databas Name"
  type        = string
  default     = "postgres"
}

variable "db_user_name" {
  description = "Databas User Name"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Databas User Password"
  type        = string
  default     = "postgres"
}
