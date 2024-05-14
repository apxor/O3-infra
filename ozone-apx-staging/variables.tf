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

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "The CIDR block for the private subnet"
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

variable "enabled_cluster_log_types" {
  description = "The enabled log types for EKS cluster"
  type        = list(string)
  default     = []
}

variable "instance_key" {
  description = "Name of the EC2 isntance key created for access to instances"
  type        = string
}



