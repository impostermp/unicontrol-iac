output "alb_arn" {
  value = aws_lb.application_lb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.application_target_group.arn
}

output "listener_arn" {
  value = aws_lb_listener.application_listener.arn
}
