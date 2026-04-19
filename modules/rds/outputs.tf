# Donovan-Codes : Exposing RDS Endpoint as Sensitive Output for App Connection String
output "db_endpoint" {
  description = "RDS endpoint (host:port)"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

# Donovan-Codes : Exposing Database Name for Reference in Application Configuration
output "db_name" {
  description = "Name of the database on the RDS instance"
  value       = aws_db_instance.main.db_name
}
