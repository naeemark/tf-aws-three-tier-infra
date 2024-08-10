###########################################################
# Application Load Balancer Configs 
###########################################################

# Create ALB
resource "aws_lb" "alb" {
  name               = "bbeans-alb-${var.tf_env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids
  tags               = merge({ Name = "bbeans-alb-${var.tf_env}" }, var.tags)
}

# Create Target group
resource "aws_lb_target_group" "backend_tg_8000" {
  name     = "backend-tg-8000-${var.tf_env}"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval            = 30
    path                = "/"
    port                = 8000
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg-${var.tf_env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval            = 30
    path                = "/api"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg-${var.tf_env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval            = 30
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

# Create Load Balancer Listener
resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.frontend_tg, aws_lb_target_group.backend_tg]
  tags              = merge({ Name = "frontend-listener-http-${var.tf_env}" }, var.tags)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_lb_listener" "backend_http_8000" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8000"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.frontend_tg, aws_lb_target_group.backend_tg]
  tags              = merge({ Name = "backend-listener-http-8000-${var.tf_env}" }, var.tags)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg_8000.arn
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.frontend_http.arn
  tags         = merge({ Name = "backend-rule-${var.tf_env}" }, var.tags)
  priority     = 10

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
  # condition { host_header { values = ["example.com"] } }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
  depends_on = [aws_lb_target_group.frontend_tg, aws_lb_target_group.backend_tg]
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
#   tags              = merge({ Name = "bbeans-alb-listener-http-${var.tf_env}" }, var.tags)

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
