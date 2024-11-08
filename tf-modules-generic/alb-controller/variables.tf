variable "region" {
  description = "The region to launch the bastion host"
  type        = string
}

variable "aws_account_id" {
  description = "The aws account id"
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "oidc_id" {
  description = "The oidc id of the cluster"
  type        = string
}

variable "aws_iam_oidc_provider_arn" {
  description = "The arn of the oidc provider"
  type        = string
}

variable "vpc_id" {
  description = "The vpc id of the cluster vpc"
  type        = string
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "helm_chart_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "ALB Controller Helm chart name to be installed"
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "ALB Controller repository name."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "environment" {
  type = string
}
