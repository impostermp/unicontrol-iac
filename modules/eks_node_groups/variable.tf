variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node_groups" {
  type = map(object({
    instance_type = string
    desired_size  = number
    max_size      = number
    min_size      = number
  }))

  validation {
    condition = alltrue([for ng in var.node_groups : ng.desired_size >= 1 && ng.desired_size <= 10])
    error_message = "The desired_size must be between 1 and 10 for each node group."
  }

  validation {
    condition = alltrue([for ng in var.node_groups : ng.max_size >= 1 && ng.max_size <= 10])
    error_message = "The max_size must be between 1 and 10 for each node group."
  }

  validation {
    condition = alltrue([for ng in var.node_groups : ng.min_size >= 1 && ng.min_size <= 10])
    error_message = "The min_size must be between 1 and 10 for each node group."
  }
}

variable "environment" {
  type = string
}
variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS node group"
  type        = string
}