# networkmodule/vpc.tf
# Define VPC, Internet Gateway, and Subnet resources for Dev and Prod environments.

# Resource block to create VPC for Dev environment.
resource "aws_vpc" "main" {
  cidr_block = var.env == "dev" ? var.vpc_cidr_dev : var.vpc_cidr_prod
  tags = {
    Name = "VPC ${var.env}"
  }
}

# Resource block to create Internet Gateway for Dev VPC.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW ${var.env}"
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.env == "dev" ? length(var.public_cidr_blocks) : 0
  vpc_id = aws_vpc.main.id
  cidr_block = var.env == "dev" ? var.public_cidr_blocks[count.index] : null 
  availability_zone = var.env == "dev" ? data.aws_availability_zones.available.names[count.index] : null 
  tags = merge(
    local.default_tags,
    {
      Name = "${var.env}-public-subnet-${count.index}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count = var.env == "dev" ? length(var.private_cidr_blocks_dev) : length(var.private_cidr_blocks_prod)
  vpc_id = aws_vpc.main.id
  cidr_block = var.env == "dev" ? var.private_cidr_blocks_dev[count.index] : var.private_cidr_blocks_prod[count.index] 
  availability_zone = var.env == "dev" ? data.aws_availability_zones.available.names[count.index] : data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags,
    {
      Name = "${var.env}-private-subnet-${count.index}"
    }
  )
}

# Resource block to create Public Route Table for Dev VPC.
resource "aws_route_table" "public_rt" {
  count = var.env == "dev" ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table ${var.env}"
  }
}

# Resource block to associate Public Subnets with Public Route Table of Dev VPC.
resource "aws_route_table_association" "public_subnet_assoc" {
  count = var.env == "dev" ? length(aws_subnet.public_subnet) : 0

  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_rt[0].id
}