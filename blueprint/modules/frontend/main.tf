###########################################################
# Frontend Resources
###########################################################

#Create Launch config
resource "aws_launch_configuration" "frontend_launch_config" {
  name_prefix     = "frontend-launch-config"
  image_id        = var.ami_id
  instance_type   = var.instance_type
  security_groups = var.security_group_ids
  user_data       = var.user_data_script

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = 5
    encrypted   = true
  }


  lifecycle {
    create_before_destroy = true
  }
}


# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name                 = "tf-task-asg"
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2
  force_delete         = true
  depends_on           = [aws_lb.alb]
  target_group_arns    = ["${aws_lb_target_group.tg.arn}"]
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.frontend_launch_config.name
  vpc_zone_identifier  = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]

  tag {
    key                 = "Name"
    value               = "tf-task-frontend"
    propagate_at_launch = true
  }
}
