variable "tags" {}
variable "alb_arn" {}
variable "rate_limit" {
  description = "MAX limit for the rule"
  type        = number
  default     = 1000
}
variable "evaluation_window_sec" {
  description = "Seconds to evaluate the rule"
  type        = number
  default     = 300
}