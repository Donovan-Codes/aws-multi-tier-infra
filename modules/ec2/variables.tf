# Donovan-Codes : Declaring Input Variables for EC2 Auto Scaling Module Configuration
variable "project_name" {
  description = "Project name used for resource tagging and naming"
  type        = string
}

# Donovan-Codes : Accepting VPC ID for Security Group and Network Interface Placement
variable "vpc_id" {
  description = "ID of the VPC to deploy EC2 resources into"
  type        = string
}

# Donovan-Codes : Accepting Private App Subnet IDs for Auto Scaling Group Distribution
variable "private_app_subnet_ids" {
  description = "List of private app subnet IDs for ASG placement"
  type        = list(string)
}

# Donovan-Codes : Accepting ALB Security Group ID to Scope EC2 Inbound Rules
variable "alb_security_group_id" {
  description = "Security group ID of the ALB for EC2 ingress scoping"
  type        = string
}

# Donovan-Codes : Accepting Target Group ARN to Register ASG Instances with ALB
variable "target_group_arn" {
  description = "ARN of the ALB target group for ASG registration"
  type        = string
}

# Donovan-Codes : Setting EC2 Instance Type for Launch Template
variable "instance_type" {
  description = "EC2 instance type for the launch template"
  type        = string
  default     = "t3.micro"
}

# Donovan-Codes : Defining Auto Scaling Group Minimum, Maximum, and Desired Capacity
variable "asg_min" {
  description = "Minimum number of EC2 instances in the ASG"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Maximum number of EC2 instances in the ASG"
  type        = number
  default     = 3
}

variable "asg_desired" {
  description = "Desired number of EC2 instances in the ASG"
  type        = number
  default     = 1
}
