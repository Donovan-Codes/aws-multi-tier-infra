# Donovan-Codes : Declaring Input Variables for VPC Module Configuration
variable "project_name" {
  description = "Project name used for resource tagging and naming"
  type        = string
}

# Donovan-Codes : Setting VPC CIDR Block for the Entire Network Address Space
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Donovan-Codes : Specifying Availability Zones for Multi-AZ Subnet Distribution
variable "availability_zones" {
  description = "List of AZs to use (should match subnet count)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Donovan-Codes : Defining CIDR Ranges for Public Subnets Hosting the ALB
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Donovan-Codes : Defining CIDR Ranges for Private Subnets Hosting EC2 App Tier
variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private app-tier subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# Donovan-Codes : Defining CIDR Ranges for Isolated Private Subnets Hosting RDS
variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private DB-tier subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}
