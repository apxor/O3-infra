variable "environment" {
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "availability_zones" {
  type        = list(any)
  description = "The az that the resources will be launched"
}

variable "sg_ingress_ports" {
  type = list(object({
    from     = number
    to       = number
    protocol = optional(string, "-1")
  }))
  default = [{
    from = 0
    to   = 0
  }]
  description = "The ingress ports allowed for the security group"
}
