# Donovan-Codes : Provisioning VPC with DNS Support and Hostnames Enabled
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

# ---------------------------------------------------------------
# Donovan-Codes : Defining Public and Private Subnets Across AZs
# ---------------------------------------------------------------

# Donovan-Codes : Creating Public Subnets with Auto-Assigned Public IPs for ALB
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-public-${count.index + 1}"
    Project = var.project_name
    Tier    = "public"
  }
}

# Donovan-Codes : Creating Private App Subnets for EC2 Auto Scaling Group
resource "aws_subnet" "private_app" {
  count             = length(var.private_app_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name    = "${var.project_name}-private-app-${count.index + 1}"
    Project = var.project_name
    Tier    = "app"
  }
}

# Donovan-Codes : Creating Isolated Private DB Subnets for RDS
resource "aws_subnet" "private_db" {
  count             = length(var.private_db_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name    = "${var.project_name}-private-db-${count.index + 1}"
    Project = var.project_name
    Tier    = "db"
  }
}

# ---------------------------------------------------------------
# Donovan-Codes : Attaching Internet Gateway and NAT Gateways
# ---------------------------------------------------------------

# Donovan-Codes : Attaching Internet Gateway to VPC for Public Inbound/Outbound Traffic
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

# Donovan-Codes : Allocating Elastic IPs for NAT Gateways (One Per AZ)
resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name    = "${var.project_name}-nat-eip-${count.index + 1}"
    Project = var.project_name
  }
}

# Donovan-Codes : Deploying NAT Gateways in Public Subnets for Private Outbound Traffic
resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name    = "${var.project_name}-nat-${count.index + 1}"
    Project = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

# ---------------------------------------------------------------
# Donovan-Codes : Configuring Route Tables for All Subnet Tiers
# ---------------------------------------------------------------

# Donovan-Codes : Creating Public Route Table with Default Route to Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-public-rt"
    Project = var.project_name
  }
}

# Donovan-Codes : Associating Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Donovan-Codes : Creating Private App Route Tables with Default Route Through NAT Gateway
resource "aws_route_table" "private_app" {
  count  = length(var.private_app_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name    = "${var.project_name}-private-app-rt-${count.index + 1}"
    Project = var.project_name
  }
}

# Donovan-Codes : Associating Private App Subnets with Their Respective Route Tables
resource "aws_route_table_association" "private_app" {
  count          = length(var.private_app_subnet_cidrs)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}

# Donovan-Codes : Creating Isolated DB Route Table with No Internet Egress
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-private-db-rt"
    Project = var.project_name
  }
}

# Donovan-Codes : Associating DB Subnets with Isolated Route Table
resource "aws_route_table_association" "private_db" {
  count          = length(var.private_db_subnet_cidrs)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}
