variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "List of security groups for the load balancer"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Interval for health checks (seconds)"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout for health checks (seconds)"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of healthy checks before considering healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of unhealthy checks before considering unhealthy"
  type        = number
  default     = 3
}

variable "listener_port" {
  description = "Port for the listener"
  type        = number
}

variable "listener_protocol" {
  description = "Protocol for the listener"
  type        = string
  default     = "HTTP"
}
variable "green_target_group_name" {
  description = "Name of the green target group"
  type        = string
}

variable "green_target_group_port" {
  description = "Port for the green target group"
  type        = number
}

variable "green_target_group_protocol" {
  description = "Protocol for the green target group"
  type        = string
}
variable "blue_traffic_weight" {
  description = "Traffic weight for the blue target group"
  type        = number
  default     = 100
}

variable "green_traffic_weight" {
  description = "Traffic weight for the green target group"
  type        = number
  default     = 0
}

variable "vpc_id" {
  description = "VPC ID"
  type        = number
}
