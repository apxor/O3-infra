/* Default required buckets for functioning */

# module "apx-o3-secor-chunks" {
#   source                         = "./tf-modules-generic/s3-bucket"
#   bucket_name                    = "apx-o3-${var.environment}-secor-chunks"
#   create_user_access_credentials = true
# }

module "apx-o3-secor-events" {
  source                         = "../tf-modules-generic/s3-bucket"
  bucket_name                    = "apx-o3-${var.environment}-secor-events"
  create_user_access_credentials = true
}

module "apx-o3-ch-archives" {
  source                         = "../tf-modules-generic/s3-bucket"
  bucket_name                    = "apx-o3-${var.environment}-ch-archives"
  create_user_access_credentials = true
}

module "apx-o3-campaign-resource" {
  source                         = "../tf-modules-generic/s3-bucket"
  bucket_name                    = "apx-o3-${var.environment}-campaign-resource"
  create_user_access_credentials = true
}

module "apx-o3-cohorts" {
  source                         = "../tf-modules-generic/s3-bucket"
  bucket_name                    = "apx-o3-${var.environment}-cohorts"
  create_user_access_credentials = true
}

module "apx-o3-dashboard-downloads" {
  source                         = "../tf-modules-generic/s3-bucket"
  bucket_name                    = "apx-o3-${var.environment}-dashboard-downloads"
  create_user_access_credentials = true
}

module "apx-o3-pg-backrest" {
  source                         = "../tf-modules-generic/s3-bucket"
  bucket_name                    = "apx-o3-${var.environment}-dashboard-downloads"
  create_user_access_credentials = true
}

module "apx-o3-spark" {
  source                         = "../tf-modules-generic/s3-bucket"
  bucket_name                    = "apx-o3-${var.environment}-spark"
  create_user_access_credentials = true
}
