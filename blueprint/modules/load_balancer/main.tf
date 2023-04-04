###########################################################
# Application Load Balancer Configs 
###########################################################

# Create Target group
resource "aws_lb_target_group" "tg" {
  name     = "tf-task-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval            = 70
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}



# Create ALB
resource "aws_lb" "alb" {
  name               = "tf-task-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  tags = {
    Name    = "tf-task-alb"
    Project = "tf-task"
  }
}

# Create ALB Listener 
resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
