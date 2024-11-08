/* Global variables */

locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

/* Import Networking Module */

# module "networking" {
#   source               = "../tf-modules/networking"
#   region               = var.region
#   environment          = var.environment
#   vpc_cidr             = var.vpc_cidr
#   public_subnets_cidr  = var.public_subnets_cidr
#   private_subnets_cidr = var.private_subnets_cidr
#   availability_zones   = local.production_availability_zones
# }

/* Import default-iam Module */

module "default-iam" {
  source      = "../tf-modules-generic/default-iam"
  environment = var.environment
  region      = var.region
}

/* Create the EKS Cluster */

resource "aws_eks_cluster" "eks_cluster" {
  depends_on                = [module.default-iam]
  name                      = var.cluster_name
  role_arn                  = module.default-iam.cluster_role_arn
  version                   = var.cluster_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  tags = {
    "env" = var.environment
  }
  vpc_config {
    subnet_ids         = concat(var.private_subnets_ids_zone_a, var.private_subnets_ids_zone_b, var.private_subnets_ids_zone_c)
    security_group_ids = var.security_groups_ids
  }
}

/* Import oidc Module */

module "oidc" {
  depends_on   = [aws_eks_cluster.eks_cluster]
  source       = "../tf-modules-generic/oidc"
  cluster_name = var.cluster_name
}

/* Import EBS add on */

module "ebs-driver-addon" {
  depends_on                   = [aws_eks_cluster.eks_cluster, module.oidc, module.ng-temp]
  source                       = "../tf-modules-generic/ebs-csi-driver"
  region                       = var.region
  cluster_name                 = var.cluster_name
  oidc_id                      = module.oidc.oidc_id
  aws_iam_oidc_provider_arn    = module.oidc.aws_iam_oidc_provider_arn
  ebs_snapshotter_force_enable = var.ebs_snapshotter_force_enable
  ebs_driver_version           = var.ebs_driver_version
  kms_key_arn                  = var.kms_key_arn
  environment                  = var.environment
}

/* Import cluster-autoscaler Module */

module "autoscaler" {
  depends_on                = [aws_eks_cluster.eks_cluster, module.oidc, module.ng-temp]
  source                    = "../tf-modules-generic/cluster-autoscaler"
  region                    = var.region
  aws_account_id            = var.aws_account_id
  oidc_id                   = module.oidc.oidc_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  cluster_name              = var.cluster_name
  environment               = var.environment
}

/* Import alb-controller Module */

module "alb-controller" {
  depends_on                = [module.oidc]
  source                    = "../tf-modules-generic//alb-controller"
  region                    = var.region
  aws_account_id            = var.aws_account_id
  cluster_name              = var.cluster_name
  oidc_id                   = module.oidc.oidc_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  vpc_id                    = var.vpc_id
  enabled                   = true
}
