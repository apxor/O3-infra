variable "region" {
  description = "The region to launch the bastion host"
  type        = string
}

variable "oidc_id" {
  description = "The oidc id of the cluster"
  type        = string
}

variable "aws_iam_oidc_provider_arn" {
  description = "The arn of the oidc provider"
  type        = string
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

variable "cluster_name" {
  type        = string
  description = "The name of the eks cluster"
}

variable "ebs_driver_name" {
  type        = string
  description = "The name of the eks ebs addon"
  default     = "aws-ebs-csi-driver"
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
