# Donovan-Codes : Declaring Input Variables for ALB Module Configuration
variable "project_name" {
  description = "Project name used for resource tagging and naming"
  type        = string
}

# Donovan-Codes : Accepting VPC ID from VPC Module Output for Security Group Placement
variable "vpc_id" {
  description = "ID of the VPC to deploy the ALB into"
  type        = string
}

# Donovan-Codes : Accepting Public Subnet IDs from VPC Module for Multi-AZ ALB Deployment
variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB placement"
  type        = list(string)
}
