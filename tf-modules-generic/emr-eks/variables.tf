variable "aws_region" {
  description = "The aws region"
  type        = string
}

variable "sso_profile" {
  description = "The sso profile to use"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the eks cluster"
  type        = string
}

variable "eks_namespaces" {
  description = "The namespace for the eks cluster"
  type        = list(string)
  default     = []
}

variable "oidc_id" {
  description = "The oidc id of the cluster"
  type        = string
}

variable "emr_bucket" {
  description = "The bucket to use for EMR resources"
  type        = string
}

variable "emr_cluster_name" {
  description = ""
  type        = string
}
