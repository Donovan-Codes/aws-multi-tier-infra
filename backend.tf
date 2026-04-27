# Donovan-Codes : Configuring S3 Backend for Remote State with DynamoDB Locking
terraform {
  backend "s3" {
    bucket         = "donovan-multi-tier-tfstate-b8753066"
    key            = "multi-tier/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "donovan-multi-tier-tfstate-locks"
    encrypt        = true
  }
}
