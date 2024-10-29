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


# nudging buckets

module "apx-o3-secor-chunks-nudging" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-secor-chunks-nudging"
  create_user_access_credentials = true
}

module "apx-o3-secor-events-nudging" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-secor-events-nudging"
  create_user_access_credentials = true
}

module "apx-o3-ch-archives-nudging" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-ch-archives-nudging"
  create_user_access_credentials = true
}

module "apx-o3-campaign-resource-nudging" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-campaign-resource-nudging"
  create_user_access_credentials = true
}

module "apx-o3-cohorts-nudging" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-cohorts-nudging"
  create_user_access_credentials = true
}

module "apx-o3-dashboard-downloads-nudging" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-dashboard-downloads-nudging"
  create_user_access_credentials = true
}

module "apx-o3-pg-backrest-nudging" {
  source                         = "../tf-modules/s3-bucket"
  bucket_name                    = "apx-o3-dashboard-downloads-nudging"
  create_user_access_credentials = true
}
