# # Define outputs for dev environment, such as Load Balancer DNS and Bastion Host public IP.

# # Output DNS name of the Load Balancer.
# output "load_balancer_dns" {
#   value       = aws_lb.app_lb.dns_name
#   description = "DNS name of the Load Balancer"
# }

# # Output Public IP of the Bastion VM.
# output "bastion_public_ip" {
#   value       = aws_instance.bastion_vm.public_ip
#   description = "Public IP of the Bastion VM"
# }

# # Output security group ID for VMs in webserver module.
# output "vm_dev_sg_id" {
#   value = aws_security_group.vm_dev_sg.id
# }

# # Output the private IP addresses of all instances
# output "vm_private_ips" {
#   value = {
#     vm1        = aws_instance.vm1.private_ip
#     vm2        = aws_instance.vm2.private_ip
#     vm3        = aws_instance.vm3.private_ip
#     vm4        = aws_instance.vm4.private_ip
#     bastion_vm = aws_instance.bastion_vm.private_ip
#   }
#   description = "Private IP addresses of all instances"
# }

# output "bastion_sg_id" {
#   value = aws_security_group.bastion_sg.id
# }