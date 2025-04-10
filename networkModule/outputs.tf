# networkmodule/outputs.tf
# Define outputs for network module, such as VPC and subnet IDs.

output "vpc_id" {
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = var.env == "dev" ? aws_subnet.public_subnet[*].id : null
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_route_table_id" {
  value = aws_vpc.main.main_route_table_id
}

output "public_subnet_route_table_id" {
  value = aws_route_table.public_rt[*].id
}