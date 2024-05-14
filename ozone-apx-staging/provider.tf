/* Define Providers */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.26.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
  }

  backend "s3" {
    bucket              = "<Provide Bucket Name here for remote backend of state>"
    key                 = "<Provide path to save tf state at>"
    region              = "<Provide AWS Region>"
    profile             = "<Provide AWS SSO Credentials Profile Name here>"
    allowed_account_ids = ["<Provide AWS account ID>"]
  }
}

provider "aws" {
  region              = var.region
  profile             = var.sso_profile
  allowed_account_ids = [var.aws_account_id]
  default_tags {
    tags = {
      "environment"         = var.environment
      "cluster"             = var.cluster_name
      "resource-managed-by" = "terraform"
    }
  }
}
