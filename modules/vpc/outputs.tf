# Donovan-Codes : Exposing VPC ID for Reference by Downstream Modules
output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

# Donovan-Codes : Exposing Public Subnet IDs for ALB and NAT Gateway Placement
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

# Donovan-Codes : Exposing Private App Subnet IDs for EC2 Auto Scaling Group
output "private_app_subnet_ids" {
  description = "List of private app subnet IDs"
  value       = aws_subnet.private_app[*].id
}

# Donovan-Codes : Exposing Private DB Subnet IDs for RDS Subnet Group
output "private_db_subnet_ids" {
  description = "List of private DB subnet IDs"
  value       = aws_subnet.private_db[*].id
}
