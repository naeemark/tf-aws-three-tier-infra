output "endpoint" {
  description = "database endpoint"
  value       = length(aws_db_instance.rds) > 0 ? aws_db_instance.rds[0].address : "N/A"
}
