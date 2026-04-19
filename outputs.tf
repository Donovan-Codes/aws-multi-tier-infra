# Donovan-Codes : Exposing Key Deployment Outputs After Terraform Apply Completes

# Donovan-Codes : Printing ALB DNS Name as the Public URL to Verify the Deployment
output "alb_dns_name" {
  description = "Paste this into your browser to verify the deployment"
  value       = module.alb.alb_dns_name
}

# Donovan-Codes : Exposing VPC ID for Reference in Future Terraform Workspaces
output "vpc_id" {
  description = "ID of the deployed VPC"
  value       = module.vpc.vpc_id
}

# Donovan-Codes : Exposing ASG Name for Use in CloudWatch and Manual Scaling Operations
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.ec2.asg_name
}

# Donovan-Codes : Exposing RDS Endpoint as Sensitive Output to Prevent Terminal Leakage
output "db_endpoint" {
  description = "RDS connection endpoint — retrieve with: terraform output db_endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}
