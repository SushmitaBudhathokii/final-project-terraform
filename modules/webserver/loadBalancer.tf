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