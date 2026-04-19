# Donovan-Codes : Declaring Input Variables for RDS Module Configuration
variable "project_name" {
  description = "Project name used for resource tagging and naming"
  type        = string
}

# Donovan-Codes : Accepting VPC ID for RDS Security Group Placement
variable "vpc_id" {
  description = "ID of the VPC to deploy RDS into"
  type        = string
}

# Donovan-Codes : Accepting Private DB Subnet IDs for RDS Subnet Group
variable "private_db_subnet_ids" {
  description = "List of private DB subnet IDs for the RDS subnet group"
  type        = list(string)
}

# Donovan-Codes : Accepting EC2 Security Group ID to Scope RDS Inbound Rules
variable "ec2_security_group_id" {
  description = "Security group ID of the EC2 app tier for RDS ingress scoping"
  type        = string
}

# Donovan-Codes : Setting RDS Instance Class for the Database Tier
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

# Donovan-Codes : Setting Initial Database Name Created on RDS Instance
variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "appdb"
}

# Donovan-Codes : Accepting Sensitive RDS Master Username from Root Variables
variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

# Donovan-Codes : Accepting Sensitive RDS Master Password from Root Variables
variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
