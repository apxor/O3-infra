/* Kubernetes Service Accounts */

module "secor-sa" {
  source                    = "../tf-modules-generic/iam-sa"
  service_account_name      = "secor-sa"
  namespace                 = "secor"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-secor-events.bucket_name]
  environment               = var.environment
}

module "ingestor_sa" {
  source                    = "../tf-modules-generic/iam-sa"
  service_account_name      = "ingestor-workload"
  namespace                 = "ingestor"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-secor-events.bucket_name]
  environment               = var.environment
}

module "loki_sa" {
  source                    = "../tf-modules-generic/iam-sa"
  service_account_name      = "loki-workload"
  namespace                 = "loki"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-loki.bucket_name]
  environment               = var.environment
}

# module "mongo_sa" {
#   source                    = "../tf-modules-generic/iam-sa"
#   service_account_name      = "mongo-backup-restore"
#   namespace                 = "meta-mongo"
#   region                    = var.region
#   oidc_id                   = module.oidc.oidc_id
#   aws_account_id            = var.aws_account_id
#   aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
#   access_to_s3_buckets      = [module.apx-o3-mongo-dumps-bucket.bucket_name]
#   environment               = var.environment
# }

# module "redis_sa" {
#   source                    = "../tf-modules-generic/iam-sa"
#   service_account_name      = "redis-backup-restore"
#   namespace                 = "bloomd-redis"
#   region                    = var.region
#   oidc_id                   = module.oidc.oidc_id
#   aws_account_id            = var.aws_account_id
#   aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
#   access_to_s3_buckets      = [module.apx-o3-redis-dumps-bucket.bucket_name]
#   environment               = var.environment
# }

module "apxorapi_sa" {
  source                    = "../tf-modules-generic/iam-sa"
  service_account_name      = "apxorapi"
  namespace                 = "apxorapi"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-dashboard-downloads.bucket_name, module.apx-o3-campaign-resources.bucket_name]
  environment               = var.environment
}


module "postgres_sa" {
  source                    = "../tf-modules-generic/iam-sa"
  service_account_name      = "postgres"
  namespace                 = "postgres"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-postgres-backup.bucket_name]
  environment               = var.environment
}
