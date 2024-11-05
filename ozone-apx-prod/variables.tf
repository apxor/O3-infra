/*-------------------------------
  Environment level variables
---------------------------------*/

variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "The Deployment environment"
}

variable "aws_account_id" {
  type        = string
  description = "The aws account id"
}

variable "sso_profile" {
  type        = string
  description = "name of the AWS SSO credentials profile"
}

/*-------------------------------
  variables for networking module
---------------------------------*/

# variable "vpc_cidr" {
#   type        = string
#   description = "The CIDR block of the vpc"
# }

# variable "public_subnets_cidr" {
#   type        = list(string)
#   description = "The CIDR block for the public subnet"
# }

# variable "private_subnets_cidr" {
#   type        = list(string)
#   description = "The CIDR block for the private subnet"
# }

variable "vpc_id" {
  type        = string
  description = "id of the vpc"
}

variable "private_subnets_ids_zone_a" {
  type        = list(string)
  description = "list of private subnet ids for zone a"
}

variable "private_subnets_ids_zone_b" {
  type        = list(string)
  description = "list of private subnet ids for zone b"
}

variable "private_subnets_ids_zone_c" {
  type        = list(string)
  description = "list of private subnet ids for zone c"
}

variable "security_groups_ids" {
  type        = list(string)
  description = "list of security group ids"
}

/*-------------------------------
  variables for EKS cluster
---------------------------------*/

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  description = "Version of the EKS cluster"
}

variable "ebs_driver_version" {
  type        = string
  description = "The version of the eks ebs addon"
}

variable "ebs_snapshotter_force_enable" {
  type        = bool
  description = "Whether to force enable the snapshotter sidecar"
  default     = false
}

variable "enabled_cluster_log_types" {
  description = "The enabled log types for EKS cluster"
  type        = list(string)
  default     = []
}

variable "instance_key" {
  description = "Name of the EC2 isntance key created for access to instances"
  type        = string
}

variable "kms_key_arn" {
  description = "the arn of the kms key"
  type        = string
  default     = ""
}