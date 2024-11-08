/* Default required buckets for functioning */

module "apx-o3-secor-chunks-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-secor-chunks"
}

module "apx-o3-secor-events-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-secor-events"
}

module "apx-o3-ch-archives-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-ch-archives"
}

module "apx-o3-terraform-state-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-tf-state"
}

module "apx-o3-loki-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-loki"
}

module "apx-o3-mongo-dumps-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-mongo-dumps"
}

module "apx-o3-redis-dumps-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-redis-dumps"
}

module "apx-o3-dashboard-downloadables-bucket" {
  source      = "../tf-modules-generic/s3-bucket"
  bucket_name = "apx-o3-${var.environment}-dashboard-downloadables"
}
