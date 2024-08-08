###########################################################
# Backend Resources
###########################################################

# Create Launch config
resource "aws_launch_configuration" "backend_launch_config" {
  name_prefix     = "backend-launch-config"
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
  name                 = var.asg_name
  max_size             = var.max_asg_capacity
  min_size             = var.min_asg_capacity
  desired_capacity     = var.desired_asg_capacity
  force_delete         = true
  target_group_arns    = var.alb_target_group_arns
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.backend_launch_config.name
  vpc_zone_identifier  = var.private_subnet_ids

  tag {
    key                 = "Name"
    value               = "bbeans-backend"
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    value               = "bbeans"
    propagate_at_launch = true
  }
  tag {
    key                 = "Owner"
    value               = "itadmin"
    propagate_at_launch = true
  }
}

# to use a single instance instead of AutoScallingGroup
# resource "aws_instance" "backend" {
#   ami                    = var.ami_id
#   instance_type          = var.instance_type
#   subnet_id              = var.private_subnet_ids[0]
#   vpc_security_group_ids = var.security_group_ids
#   key_name                    = var.key_pair_name
#   user_data              = var.user_data_script
#   tags                   = merge({ Name = "bbeans-backend" }, var.tags)
# }
