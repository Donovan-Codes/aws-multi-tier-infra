# Donovan-Codes : Configuring Terraform Requirements and AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

# Donovan-Codes : Initializing AWS Provider in Target Region
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "donovan-multi-tier"
}

# Donovan-Codes : Creating S3 Bucket for Terraform Remote State Storage
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-tfstate-${random_id.suffix.hex}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "Terraform State"
    Project = var.project_name
  }
}

# Donovan-Codes : Generating Unique Suffix to Ensure Globally Unique Bucket Name
resource "random_id" "suffix" {
  byte_length = 4
}

# Donovan-Codes : Enabling Versioning on State Bucket for State History and Recovery
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Donovan-Codes : Applying AES-256 Server-Side Encryption to State Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Donovan-Codes : Blocking All Public Access to State Bucket
resource "aws_s3_bucket_public_access_block" "state_public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Donovan-Codes : Provisioning DynamoDB Table for Terraform State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.project_name}-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "Terraform State Locks"
    Project = var.project_name
  }
}

# Donovan-Codes : Outputting Bootstrap Values for Use in Root Backend Configuration
output "state_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
