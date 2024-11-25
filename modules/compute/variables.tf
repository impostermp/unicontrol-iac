variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

# Node group configurations as a map, allowing different groups per environment
variable "node_groups" {
  type = map(object({
    instance_type = string
    desired_size  = number
    max_size      = number
    min_size      = number
  }))
}

variable "environment" {
  type = string
}
