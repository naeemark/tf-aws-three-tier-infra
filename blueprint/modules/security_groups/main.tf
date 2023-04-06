###########################################################
# Security Groups
###########################################################

# Create security group for load balancer
resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = var.alb_sg_description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge({ Name = "tf-task-alb-sg" }, var.tags)
}

# Conditional block to allow http over port:80
resource "aws_security_group_rule" "alb_sg_rule_http" {
  security_group_id = aws_security_group.alb_sg.id
  count             = var.alb_sg_allow_http ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  description       = "HTTP"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Create security group for frontend
resource "aws_security_group" "frontend_sg" {
  name        = var.frontend_sg_name
  description = var.frontend_sg_description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = var.frontend_sg_inbound_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge({ Name = "tf-task-frontend-sg" }, var.tags)
}

# Conditional block to open port:22
resource "aws_security_group_rule" "frontend_sg_rule_ssh" {
  security_group_id = aws_security_group.frontend_sg.id
  count             = var.frontend_sg_allow_ssh ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "HTTP"
  cidr_blocks       = var.frontend_sg_inbound_cidr_blocks
}

# Create security group for database
resource "aws_security_group" "database_sg" {
  name        = var.database_sg_name
  description = var.database_sg_description
  vpc_id      = var.vpc_id

  ingress {
    description     = format("Allows Trafic on Port: %s", var.database_instance_port)
    from_port       = var.database_instance_port
    to_port         = var.database_instance_port
    protocol        = "tcp"
    security_groups = length(aws_security_group.bastion_sg) > 0 ? [aws_security_group.backend_sg.id, aws_security_group.bastion_sg[0].id] : [aws_security_group.backend_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge({ Name = "tf-task-database-sg" }, var.tags)

}

# Create security group for backend
resource "aws_security_group" "backend_sg" {
  name        = var.backend_sg_name
  description = var.backend_sg_description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = var.backend_sg_inbound_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge({ Name = "tf-task-backend-sg" }, var.tags)
}

# Conditional block to open port:22
resource "aws_security_group_rule" "backend_sg_rule_ssh" {
  security_group_id = aws_security_group.backend_sg.id
  count             = var.backend_sg_allow_ssh ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "HTTP"
  cidr_blocks       = var.backend_sg_inbound_cidr_blocks
}

# Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "sg for bastion"
  vpc_id      = var.vpc_id
  count       = var.required_bastion_setup ? 1 : 0 # Condition to control Bastion Host Creation

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = var.bastion_sg_inbound_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = var.bastion_sg_inbound_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge({ Name = "tf-task-bastion-sg" }, var.tags)
}
