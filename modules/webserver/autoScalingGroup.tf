resource "aws_launch_template" "web_server" {
  name_prefix   = "webserver-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.webserver_sg.id]
  }

  user_data = base64encode(templatefile("${path.module}/userdata_webserver.tpl", {}))
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