# networkmodule/nat_gateway.tf

# Resource block to create Elastic IP for NAT Gateway (only for Dev).
resource "aws_eip" "nat_gateway_eip" {
  count = var.env == "dev" ? 1 : 0
  vpc   = true
  tags = {
    Name = "NAT Gateway EIP - ${var.env}"
  }
}

# Resource block to create NAT Gateway in Public Subnet 1 of Dev VPC.
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.env == "dev" ? 1 : 0
  allocation_id = aws_eip.nat_gateway_eip[0].id
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
  tags = {
    Name = "NAT Gateway - ${var.env}"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_default_route_table" "private_rt" {
  # Create a private route table for both dev and prod
  count = var.env == "dev" || var.env == "prod" ? 1 : 0

  default_route_table_id = aws_vpc.main.default_route_table_id

  # Conditionally add the route only for the dev environment
  dynamic "route" {
    for_each = var.env == "dev" ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
    }
  }

  tags = {
    Name = "Private Route Table - ${var.env}"
  }
}
