# Donovan-Codes : Configuring S3 Backend for Remote State with DynamoDB Locking
terraform {
  backend "s3" {
    bucket         = "REPLACE_WITH_YOUR_BUCKET_NAME"
    key            = "multi-tier/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "REPLACE_WITH_YOUR_DYNAMODB_TABLE"
    encrypt        = true
  }
}
