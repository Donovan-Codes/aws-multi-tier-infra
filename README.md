# Multi-Tier AWS Infrastructure with Terraform

A production-style, modular Terraform project provisioning a fully functional multi-tier AWS architecture with remote state management.

## Architecture

```
Internet
   │
   ▼
Application Load Balancer (public subnets, multi-AZ)
   │
   ▼
EC2 Auto Scaling Group (private app subnets, multi-AZ)
   │
   ▼
RDS MySQL (private DB subnets, multi-AZ)
```

**Remote state:** S3 bucket (versioned + encrypted) + DynamoDB table (state locking)

## Infrastructure components

| Component | Details |
|---|---|
| VPC | 10.0.0.0/16, 6 subnets across 2 AZs |
| Public subnets | ALB, NAT Gateways |
| Private app subnets | EC2 Auto Scaling Group |
| Private DB subnets | RDS MySQL 8.0 |
| ALB | HTTP listener, health checks, target group |
| EC2 ASG | Launch template, min/max/desired, CloudWatch scaling policies |
| RDS | db.t3.micro, encrypted, 7-day backup retention |
| IAM | EC2 instance role with SSM access (no bastion needed) |
| CloudWatch | CPU alarms driving scale-up (>70%) and scale-down (<20%) |

## Prerequisites

- [Terraform >= 1.5.0](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI configured (`aws configure`)
- An AWS account with sufficient IAM permissions

## Deployment

### 1. Bootstrap remote state (one-time)

```bash
cd bootstrap/
terraform init
terraform apply
# Note the outputs: state_bucket_name and dynamodb_table_name
```

### 2. Configure backend

Edit `backend.tf` with the values from the bootstrap output:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-bucket-name-here"
    key            = "multi-tier/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-dynamodb-table-here"
    encrypt        = true
  }
}
```

### 3. Set your variables

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values (never commit this file)
```

### 4. Deploy

```bash
terraform init
terraform plan
terraform apply
```

After apply completes, grab the ALB DNS name from outputs:

```bash
terraform output alb_dns_name
```

Open that URL in your browser — you should see the app page showing the instance ID and AZ.

### 5. Tear down (to avoid AWS charges)

```bash
terraform destroy
```

## Module structure

```
modules/
├── vpc/    # VPC, subnets, IGW, NAT Gateways, route tables
├── alb/    # ALB, security group, target group, listener
├── ec2/    # Launch template, ASG, IAM role, CloudWatch alarms
└── rds/    # RDS instance, subnet group, security group
```

## Security highlights

- EC2 instances have **no public IPs** and live in private subnets
- RDS is **not publicly accessible** and only accepts traffic from the EC2 security group
- ALB is the only internet-facing resource
- EC2 instances use **SSM Session Manager** instead of SSH (no open port 22, no key pairs)
- S3 state bucket is **encrypted, versioned, and blocks all public access**
- All sensitive outputs (DB password, endpoint) are marked `sensitive = true`

## Skills demonstrated

`Terraform` `AWS VPC` `EC2 Auto Scaling` `ALB` `RDS` `IAM` `CloudWatch` `Remote State` `S3` `DynamoDB` `Infrastructure as Code`
