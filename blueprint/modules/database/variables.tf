
variable "private_subnet_ids" {}
variable "security_group_ids" {}
variable "db_port" {}

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
  default     = "gp2"
}

variable "db_engine" {
  description = "Databas Engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Databas Engine Version"
  type        = string
  default     = "5.7"
}

variable "db_name" {
  description = "Databas Name"
  type        = string
  default     = "tf_task_db"
}

variable "db_user_name" {
  description = "Databas User Name"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Databas User Password"
  type        = string
  default     = "passw0rd"
}
