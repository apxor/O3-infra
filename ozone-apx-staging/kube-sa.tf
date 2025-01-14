/* Kubernetes Service Accounts */

module "secor-sa" {
  source                    = "../tf-modules/iam-sa"
  service_account_name      = "secor-sa"
  namespace                 = "secor"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-secor-events.bucket_name]
}

module "apxorapi-sa" {
  source                    = "../tf-modules/iam-sa"
  service_account_name      = "apxorapi-sa"
  namespace                 = "apxorapi"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-dashboard-downloadables.bucket_name]
}

module "data-download-sa" {
  source                    = "../tf-modules/iam-sa"
  service_account_name      = "dd-sa"
  namespace                 = "data-download"
  region                    = var.region
  oidc_id                   = module.oidc.oidc_id
  aws_account_id            = var.aws_account_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  access_to_s3_buckets      = [module.apx-o3-dashboard-downloadables.bucket_name]
}
