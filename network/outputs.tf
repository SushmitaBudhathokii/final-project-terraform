# Define outputs for prod network module, derived from the networkmodule outputs.

output "vpc_id" {
  value = module.network.vpc_id
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "prod_route_table_id" {
  value = module.network.vpc_route_table_id[*]
}
