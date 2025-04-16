resource "aws_security_group" "load_balancer_sg" {
  name        = "load-balancer-sg"
  description = "Security group for load balancer"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-load-balancer-security-group"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-bastion-security-group"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Security group for webservers"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id, aws_security_group.load_balancer_sg.id]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-webserver-security-group"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "database-sg"
  description = "Security group for datrabase instance"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  # Allow inbound PostgreSQL traffic from the webservers SG.
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  tags = {
    Name = "${var.env}-database-security-group"
  }
}

resource "aws_security_group" "private_security_group" {
  name        = "private-security-group"
  description = "Security group for private instances"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id, aws_security_group.load_balancer_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-private-security-group"
  }
}