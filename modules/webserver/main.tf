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

# Bastion Instance Configuration
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

resource "aws_eip" "bastion_eip" {
  instance = data.aws_instance.bastion_instance_detail.id
  vpc      = true
  depends_on = [data.aws_instances.bastion_instance, aws_security_group.bastion_sg]
}

# Database Server
resource "aws_instance" "dbserver5" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
  key_name      = aws_key_pair.key_pair.key_name
  security_groups = [aws_security_group.database_sg.id, aws_security_group.private_security_group.id]
  user_data = base64encode(templatefile("${path.module}/userdata_db.tpl", {}))
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

