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
  max_size             = var.asg_capacity
  min_size             = var.asg_capacity
  desired_capacity     = var.asg_capacity
  force_delete         = true
  target_group_arns    = var.alb_target_group_arns
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.frontend_launch_config.name
  vpc_zone_identifier  = var.private_subnet_ids

  tag {
    key                 = "Name"
    value               = "tf-task-frontend"
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    value               = "tf-task"
    propagate_at_launch = true
  }
  tag {
    key                 = "Owner"
    value               = "ccs_it"
    propagate_at_launch = true
  }
}
