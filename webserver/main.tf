# Configure Terraform settings, AWS provider, and data sources for the dev webserver module.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure AWS provider for us-east-1 region.
provider "aws" {
  region = "us-east-1"
}

# Data source to get available availability zones in us-east-1 region.
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source to get latest Amazon Linux 2 AMI.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn*2023*-x86_64-gp2"]
  }
}

# Data source to fetch remote state outputs from dev network module.
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "final-project-terraform-staging"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

# # Web Server Configuration
# resource "aws_launch_configuration" "web_server" {
#   image_id        = data.aws_ami.amazon_linux_2023.id
#   instance_type   = "t2.micro"
#   key_name        = aws_key_pair.key_pair.key_name
#   security_groups = [aws_security_group.webserver_sg.id] # Add security groups here
#   associate_public_ip_address = true
#   lifecycle {
#     create_before_destroy = true
#   }
#   user_data = templatefile("userdata_webserver.tpl", {})
# }

resource "aws_launch_template" "web_server" {
  name_prefix   = "webserver-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.webserver_sg.id]
  }

  user_data = base64encode(templatefile("userdata_webserver.tpl", {}))
}

# Web Server Auto Scaling Group
resource "aws_autoscaling_group" "webserver_asg" {
  # launch_configuration = aws_launch_configuration.web_server.id
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
  vpc_zone_identifier  = data.terraform_remote_state.network.outputs.public_subnet_ids
  desired_capacity     = 4
  max_size             = 4
  min_size             = 4

  health_check_type = "EC2"
  
  target_group_arns = [aws_lb_target_group.webserver_target_group.arn]

  tag {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  }
  
}

# Application Load Balancer
resource "aws_lb" "webserver_alb" {
  name               = "webserver-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.env}-webserver-load-balancer"
  }
}

# Web Server Target Group
resource "aws_lb_target_group" "webserver_target_group" {
  name     = "web-server-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.webserver_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_target_group.arn
  }
}

# # Attach Auto Scaling Group to Target Group
# resource "aws_lb_target_group_attachment" "webserver_asg" {
#   count            = 4
#   target_group_arn = aws_lb_target_group.webserver_target_group.arn
#   target_id        = aws_autoscaling_group.webserver_asg.instances[count.index].id
#   port             = 80
# }



##########################################################################################
# # Bastion VM (WebServer2)
# resource "aws_instance" "bastion" {
#   ami           = data.aws_ami.amazon_linux_2023.id
#   instance_type = "t2.micro"
#   subnet_id     = data.terraform_remote_state.network.outputs.public_subnet_ids[1]
#   key_name      = aws_key_pair.key_pair.key_name
#   security_groups = [aws_security_group.webserver_sg.id, aws_security_group.bastion_sg.id]
#   associate_public_ip_address = true
#   tags = {
#     Name = "Bastion VM"
#   }
# }
#########################################################################################

data "aws_instances" "bastion_instance" {
  filter {
    name   = "subnet-id"
    values = [data.terraform_remote_state.network.outputs.public_subnet_ids[1]]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [aws_autoscaling_group.webserver_asg]
}

data "aws_instance" "bastion_instance_detail" {
  instance_id = tolist(data.aws_instances.bastion_instance.ids)[0]
}

resource "aws_network_interface_sg_attachment" "bastion_sg_attachment" {
  depends_on = [data.aws_instances.bastion_instance, aws_security_group.bastion_sg]
  network_interface_id = data.aws_instance.bastion_instance_detail.network_interface_id
  security_group_id    = aws_security_group.bastion_sg.id
}

resource "aws_ec2_tag" "tag_bastion_instance" {
  resource_id = data.aws_instance.bastion_instance_detail.id
  key         = "Name"
  value       = "Bastion-WebServer"
}



















# Database Server
resource "aws_instance" "dbserver5" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
  key_name      = aws_key_pair.key_pair.key_name
  security_groups = [aws_security_group.database_sg.id, aws_security_group.private_security_group.id]
  tags = {
    Name = "DB Server 5"
  }
}

# VM5
resource "aws_instance" "privateServer6" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_ids[1]
  key_name      = aws_key_pair.key_pair.key_name
  security_groups = [aws_security_group.private_security_group.id]
  tags = {
    Name = "Private Server 6"
  }
}

# Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file("${var.key_name}.pub")
}

