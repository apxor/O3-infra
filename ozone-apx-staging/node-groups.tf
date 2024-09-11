/* Node groups */
/* Note: For autoscaling node group set autoscaler_enabled variable to true */

/*
  Note: d in machine primary tag denotes local ssd machines
  Eg: r6i`d`.xlarge

  Note: Use following nomenclature for naming
    - provision_types :
        spot    -> "SPOT"
        standby -> "SPOT"

    - availability_zones (subnets id's):
        1a          -> subnet_1a
        1b          -> subnet_1b
        1c          -> subnet_1c
        multi zones -> subnet_multi

  Node Group Name Format:
    - For Databases: `db-{database name}-{node provision type}-{availability zone}`
      Eg: "db-sync-redis-spot-1a"
*/

locals {
  spot_highmem_2C_16G   = "r6a.large"
  spot_highmem_4C_32G   = "r6a.xlarge"
  spot_highmem_8C_64G   = "r5a.2xlarge"
  spot_highmem_16C_128G = "r6a.4xlarge"
  spot_highmem_32C_256G = "r5a.8xlarge"

  standby_highmem_2C_16G   = "r6a.large"
  standby_highmem_4C_32G   = "r6a.xlarge"
  standby_highmem_8C_64G   = "r6a.2xlarge"
  standby_highmem_16C_128G = "r6a.4xlarge"
  standby_highmem_32C_256G = "r6a.8xlarge"

  spot_general_2C_8G    = "m6a.large"
  spot_general_4C_16G   = "m6a.xlarge"
  spot_general_8C_32G   = "m5a.2xlarge"
  spot_general_16C_64G  = "m5a.4xlarge"
  spot_general_32C_128G = "m6a.8xlarge"

  standby_general_2C_8G    = "m6a.large"
  standby_general_4C_16G   = "m5a.xlarge"
  standby_general_8C_32G   = "m5a.2xlarge"
  standby_general_16C_64G  = "m5a.4xlarge"
  standby_general_32C_128G = "m5a.8xlarge"
}

locals {
  source       = "../tf-modules/node-group"
  subnet_1a    = [module.networking.private_subnets_ids[0]]
  subnet_1b    = [module.networking.private_subnets_ids[1]]
  subnet_1c    = [module.networking.private_subnets_ids[2]]
  subnet_multi = module.networking.private_subnets_ids
}

locals {
  common_conf = {
    cluster_name       = var.cluster_name
    ec2_key            = var.instance_key
    security_group_ids = module.networking.security_groups_ids
    node_role_arn      = module.default-iam.node_group_role_arn
  }
}

locals {
  SPOT      = "SPOT"
  ON_DEMAND = "ON_DEMAND"
}

/*
  For: Clickhouse Historical Cluster
*/

module "ng-multi" {
  depends_on         = [aws_eks_cluster.eks_cluster]
  name               = "ng-multi-standby"
  instance_types     = [local.standby_general_4C_16G]
  provision_type     = local.ON_DEMAND
  autoscaler_enabled = true
  subnet_ids         = local.subnet_1a
  common_config      = local.common_conf
  source             = "../tf-modules/node-group"
  scaling_config = {
    min_size     = 0
    desired_size = 0
    max_size     = 8
  }
}
