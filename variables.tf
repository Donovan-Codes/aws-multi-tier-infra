# Donovan-Codes : Declaring Root-Level Input Variables Passed Down to All Modules

# Donovan-Codes : Setting Target AWS Region for All Resource Deployment
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

# Donovan-Codes : Setting Project Name Used Across All Resource Names and Tags
variable "project_name" {
  description = "Project name for all resource naming and tagging"
  type        = string
  default     = "donovan-multi-tier"
}

# Donovan-Codes : Setting Environment Label for Tagging and Logical Separation
variable "environment" {
  description = "Environment label (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Donovan-Codes : Defining VPC and Subnet CIDR Blocks for Network Layout
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of AZs to deploy subnets into"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private app-tier subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private DB-tier subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

# Donovan-Codes : Configuring EC2 Instance Type and Auto Scaling Group Capacity Bounds
variable "instance_type" {
  description = "EC2 instance type for the launch template"
  type        = string
  default     = "t3.micro"
}

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

# Donovan-Codes : Configuring RDS Instance Class, Database Name, and Sensitive Credentials
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the initial database to create on RDS"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS master username — set in terraform.tfvars, never commit"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password — set in terraform.tfvars, never commit"
  type        = string
  sensitive   = true
}
