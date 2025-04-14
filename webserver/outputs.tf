# # Define outputs for dev environment, such as Load Balancer DNS and Bastion Host public IP.

# Output DNS name of the Load Balancer.
output "load_balancer_dns" {
  value       = module.webserver.load_balancer_dns
  description = "DNS name of the Load Balancer"
}

# Output Public IP of the Bastion VM.
output "bastion_public_ip" {
  value       = module.webserver.bastion_public_ip
  description = "Public IP of the Bastion VM"
}

# # Output security group ID for VMs in webserver module.
# output "vm_dev_sg_id" {
#   value = module.webserver.vm_dev_sg_id
# }

# Output the private IP addresses of all instances
output "webserver_private_ips" {
  value = module.webserver.webserver_private_ips
  description = "Private IP addresses of all webserver instances"
}

# output "bastion_sg_id" {
#   value = module.webserver.bastion_sg_id
# }

output "db_private_ip" {
  value = module.webserver.db_private_ip
  description = "Private IP addresses of db instance"
}

output "vm6_private_ip" {
  value = module.webserver.vm6_private_ip
  description = "Private IP addresses of private instance"
}