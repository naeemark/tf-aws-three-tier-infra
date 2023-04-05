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
  tags               = merge({ Name = "tf-task-alb" }, var.tags)
}

# Create ALB Listener 
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.tg]
  tags              = merge({ Name = "tf-task-alb-listener-http" }, var.tags)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


# =========================================================
# HTTPS mock configuraion
# [these resources were never tested due to unavalability of a Certificate ARN]
# =========================================================
# resource "aws_lb_listener" "alb_listener_https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   depends_on        = [aws_lb_target_group.tg]
#   tags              = merge({ Name = "tf-task-alb-listener-http" }, var.tags)

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }

# resource "aws_lb_listener_certificate" "alb_listener_cert" {
#   listener_arn    = aws_alb_listener.alb_listener_https.arn
#   certificate_arn = "arn:aws:iam::xxxxxxxxx:server-certificate/certifcate"
# }

# # In case we need to use custom domain
# resource "aws_route53_record" "route" {
#   zone_id = "xxxxxxxxx"
#   name    = "www.example.com"
#   type    = "A"
#   alias {
#     name                   = aws_lb.alb.dns_name
#     zone_id                = aws_lb.alb.zone_id
#     evaluate_target_health = true
#   }
# }
# =========================================================
# HTTPS mock configuraion   //
# =========================================================
