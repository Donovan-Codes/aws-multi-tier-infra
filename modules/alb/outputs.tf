# Donovan-Codes : Exposing ALB DNS Name as the Public Entry Point for the Application
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

# Donovan-Codes : Exposing ALB ARN for Cross-Module Reference if Needed
output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

# Donovan-Codes : Exposing Target Group ARN for EC2 Auto Scaling Group Registration
output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

# Donovan-Codes : Exposing ALB Security Group ID for EC2 Ingress Rule Scoping
output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb.id
}
