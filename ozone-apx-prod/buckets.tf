/* Default required buckets for functioning */

module "apx-o3-secor-chunks" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-secor-chunks"
}

module "apx-o3-secor-events" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-secor-events"
}

module "apx-o3-ch-archives" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-ch-archives"
}
