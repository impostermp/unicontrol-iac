# modules/alb/main.tf
resource "aws_lb" "application_lb" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  tags = var.tags
}

resource "aws_lb_target_group" "application_target_group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = var.tags
}

resource "aws_lb_target_group" "green_target_group" {
  name     = var.green_target_group_name
  port     = var.green_target_group_port
  protocol = var.green_target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = var.tags
}

resource "aws_lb_listener" "application_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.application_target_group.arn
        weight = var.blue_traffic_weight
      }

      target_group {
        arn    = aws_lb_target_group.green_target_group.arn
        weight = var.green_traffic_weight
      }
    }
  }
}

