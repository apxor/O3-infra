variable "name" {
  description = "Name of the node group"
  type        = string
}

variable "provision_type" {
  description = "provision type of machines"
  type        = string
}

variable "instance_types" {
  type        = list(any)
  description = "ec2 instance type"
}

variable "autoscaler_enabled" {
  type        = bool
  description = "The az that the resources will be launched"
  default     = false
}

variable "subnet_ids" {
  type        = list(any)
  description = "list of subnet ids for node group"
}

variable "scaling_config" {
  description = "scaling config values"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
  default = {
    desired_size = 0
    min_size     = 0
    max_size     = 1
  }
}

variable "common_config" {
  description = "map having common config values"
  type = object(
    {
      cluster_name       = string
      ec2_key            = string
      node_role_arn      = string
      security_group_ids = list(string)
    }
  )
}

variable "node_group_taints" {
  description = "taints to apply for node group"
  type = list(
    object(
      {
        key    = string
        value  = string
        effect = string
      }
    )
  )
  default = []
}
