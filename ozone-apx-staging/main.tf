/* Global variables */

locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

/* Import Networking Module */

module "networking" {
  source               = "../tf-modules/networking"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones
}

/* Import default-iam Module */

module "default-iam" {
  source      = "../tf-modules/default-iam"
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
    subnet_ids         = concat(module.networking.private_subnets_ids, module.networking.public_subnets_ids)
    security_group_ids = module.networking.security_groups_ids
  }
}

/* Import oidc Module */

module "oidc" {
  depends_on   = [aws_eks_cluster.eks_cluster]
  source       = "../tf-modules/oidc"
  cluster_name = var.cluster_name
}

/* Import EBS add on */

module "ebs-driver-addon" {
  depends_on                   = [aws_eks_cluster.eks_cluster, module.oidc, module.ng-multi]
  source                       = "../tf-modules/ebs-csi-driver"
  region                       = var.region
  cluster_name                 = var.cluster_name
  oidc_id                      = module.oidc.oidc_id
  aws_iam_oidc_provider_arn    = module.oidc.aws_iam_oidc_provider_arn
  ebs_snapshotter_force_enable = var.ebs_snapshotter_force_enable
  ebs_driver_version           = var.ebs_driver_version
}

/* Import cluster-autoscaler Module */

module "autoscaler" {
  depends_on                = [aws_eks_cluster.eks_cluster, module.oidc, module.ng-multi]
  source                    = "../tf-modules/cluster-autoscaler"
  region                    = var.region
  aws_account_id            = var.aws_account_id
  oidc_id                   = module.oidc.oidc_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  cluster_name              = var.cluster_name
}

/* Import alb-controller Module */

module "alb-controller" {
  depends_on                = [module.oidc]
  source                    = "../tf-modules/alb-controller"
  region                    = var.region
  aws_account_id            = var.aws_account_id
  cluster_name              = var.cluster_name
  oidc_id                   = module.oidc.oidc_id
  aws_iam_oidc_provider_arn = module.oidc.aws_iam_oidc_provider_arn
  vpc_id                    = module.networking.vpc_id
  enabled                   = true
}


/* 
  Nudging Cluster 
*/

resource "aws_eks_cluster" "nudging_eks_cluster" {
  depends_on                = [module.default-iam]
  name                      = var.nudging_cluster_name
  role_arn                  = module.default-iam.cluster_role_arn
  version                   = var.cluster_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  tags = {
    "env" = var.environment
  }
  vpc_config {
    subnet_ids         = concat(module.networking.private_subnets_ids, module.networking.public_subnets_ids)
    security_group_ids = module.networking.security_groups_ids
  }
}

module "nudging_oidc" {
  depends_on   = [aws_eks_cluster.nudging_eks_cluster]
  source       = "../tf-modules/oidc"
  cluster_name = var.nudging_cluster_name
}

# drivers 

module "nudging-ebs-driver-addon" {
  depends_on                   = [aws_eks_cluster.nudging_eks_cluster, module.nudging_oidc, module.nudging-ng-spot]
  source                       = "../tf-modules/ebs-csi-driver"
  region                       = var.region
  cluster_name                 = var.nudging_cluster_name
  oidc_id                      = module.nudging_oidc.oidc_id
  aws_iam_oidc_provider_arn    = module.nudging_oidc.aws_iam_oidc_provider_arn
  ebs_snapshotter_force_enable = var.ebs_snapshotter_force_enable
  ebs_driver_version           = var.ebs_driver_version
}

/* Import cluster-autoscaler Module */

module "nudging-autoscaler" {
  depends_on                = [aws_eks_cluster.nudging_eks_cluster, module.nudging_oidc, module.nudging-ng-spot]
  source                    = "../tf-modules/cluster-autoscaler"
  region                    = var.region
  aws_account_id            = var.aws_account_id
  oidc_id                   = module.nudging_oidc.oidc_id
  aws_iam_oidc_provider_arn = module.nudging_oidc.aws_iam_oidc_provider_arn
  cluster_name              = var.nudging_cluster_name
}

/* Import alb-controller Module */

module "nudging-alb-controller" {
  depends_on                = [module.nudging_oidc]
  source                    = "../tf-modules/alb-controller"
  region                    = var.region
  aws_account_id            = var.aws_account_id
  cluster_name              = var.nudging_cluster_name
  oidc_id                   = module.nudging_oidc.oidc_id
  aws_iam_oidc_provider_arn = module.nudging_oidc.aws_iam_oidc_provider_arn
  vpc_id                    = module.networking.vpc_id
  enabled                   = true
}