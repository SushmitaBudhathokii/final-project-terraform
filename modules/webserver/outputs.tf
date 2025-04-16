# Define outputs for dev environment, such as Load Balancer DNS and Bastion Host public IP.

# Output DNS name of the Load Balancer.
output "load_balancer_dns" {
  value       = aws_lb.webserver_alb.dns_name
  description = "DNS name of the Load Balancer"
}

# Output Public IP of the Bastion VM.
output "bastion_public_ip" {
  value       = data.aws_instance.bastion_instance_detail.private_ip
  description = "Public IP of the Bastion VM"
}

# # Output security group ID for VMs in webserver module.
# output "vm_dev_sg_id" {
#   value = aws_security_group.vm_dev_sg.id
# }

# Output the private IP addresses of all instances
# output "webserver_private_ips" {
#   value = data.aws_instance.web_instance_details[*].private_ip]
#   description = "Private IP addresses of all instances"
# }
output "webserver_private_ips" {
  value = {
    for id, instance in data.aws_instance.web_instance_details :
    id => instance.private_ip
  }
}

output "db_private_ip" {
  value       = aws_instance.dbserver5.private_ip
  description = "Public IP of the DV VM"
}

output "vm6_private_ip" {
  value       = aws_instance.privateServer6.private_ip
  description = "Public IP of the private VM"
}

# output "bastion_sg_id" {
#   value = aws_security_group.bastion_sg.id
# }