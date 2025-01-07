/* Default required buckets for functioning */

module "apx-o3-secor-chunks" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-secor-chunks"
  create_user_access_credentials = true
}

module "apx-o3-secor-events" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-secor-events"
  create_user_access_credentials = true
}

module "apx-o3-ch-archives" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-ch-archives"
  create_user_access_credentials = true
}

module "apx-o3-dashboard-downloadables" {
  source      = "../tf-modules/s3-bucket"
  bucket_name = "apx-o3-stg-dashboard-downloadables"
}
