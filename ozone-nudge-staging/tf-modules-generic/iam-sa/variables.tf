/* variables for the IAM service account module */

variable "region" {
  description = "AWS region"
  type        = string
}

variable "oidc_id" {
  description = "OIDC ID"
  type        = string
}

variable "aws_iam_oidc_provider_arn" {
  description = "The ARN of the OIDC provider"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string

}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "namespace" {
  description = "Namespace of the service account"
  type        = string
}

variable "access_to_s3_buckets" {
  type        = list(string)
  description = "List of S3 bucket names to provide access"
  default     = null
}

variable "environment" {
  type        = string
  description = "environment name"
}
