output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "vpc_route_table_id" {
  value = module.network.vpc_route_table_id
}

output "public_subnet_route_table_id" {
  value = module.network.public_subnet_route_table_id
}
