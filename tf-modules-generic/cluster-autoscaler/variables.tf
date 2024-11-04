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

/* Helm Varibales */

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "helm_chart_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "9.29.4"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://kubernetes.github.io/autoscaler"
  description = "Helm repository"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "namespace for cluster-autoscaler and service account deployment"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "whether to create a namespace for CA deployment"
}

variable "auto_discovery_enabled" {
  type        = bool
  default     = true
  description = "variable indicating whether auto discovery is enabled or not"
}

variable "aws_account_id" {
  type        = string
  description = "the aws account id"
}

variable "environment" {
  type        = string
  description = "The environment name"
}
