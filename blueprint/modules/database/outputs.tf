output "endpoint" {
  description = "database endpoint"
  value       = aws_db_instance.rds.address
}
