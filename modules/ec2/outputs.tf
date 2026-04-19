# Donovan-Codes : Exposing ASG Name for Reference in CloudWatch and Scaling Operations
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

# Donovan-Codes : Exposing EC2 Security Group ID for RDS Ingress Rule Scoping
output "ec2_security_group_id" {
  description = "Security group ID of the EC2 instances"
  value       = aws_security_group.ec2.id
}

# Donovan-Codes : Exposing Launch Template ID for Debugging and Version Tracking
output "launch_template_id" {
  description = "ID of the EC2 launch template"
  value       = aws_launch_template.app.id
}
