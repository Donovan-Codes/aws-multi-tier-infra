# Donovan-Codes : Initializing RDS Security Group Restricting MySQL Access to App Tier Only
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow MySQL from app tier only"
  vpc_id      = var.vpc_id

  # Donovan-Codes : Opening Port 3306 Exclusively to EC2 App Security Group (Not Open Internet)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
    description     = "Allow MySQL from EC2 app tier only"
  }

  # Donovan-Codes : Allowing All Outbound Traffic for RDS Patch and Snapshot Operations
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-rds-sg"
    Project = var.project_name
  }
}

# Donovan-Codes : Creating DB Subnet Group Spanning Private DB Subnets Across AZs
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name
  }
}

# Donovan-Codes : Provisioning Encrypted MySQL RDS Instance in Isolated Private Subnet Group
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  # Donovan-Codes : Setting Database Name and Credentials from Sensitive Input Variables
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Donovan-Codes : Keeping Instance Private with Backup Retention and No Public Endpoint
  multi_az                = false  # Set to true for prod
  publicly_accessible     = false
  skip_final_snapshot     = true   # Set to false for prod
  deletion_protection     = false  # Set to true for prod
  backup_retention_period = 7

  tags = {
    Name    = "${var.project_name}-db"
    Project = var.project_name
  }
}
