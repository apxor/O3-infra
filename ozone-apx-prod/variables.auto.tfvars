/* Variables for AWS environemnt */

region         = "ap-south-1"
environment    = ""
aws_account_id = ""
sso_profile    = "default"

/* Variables for Networking module */

# vpc_cidr             = "10.0.0.0/16"
# private_subnets_cidr = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
# public_subnets_cidr  = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]

vpc_id                     = ""
private_subnets_ids_zone_a = []
private_subnets_ids_zone_b = []
private_subnets_ids_zone_c = []
security_groups_ids        = []

/* Variables for EKS */

cluster_name    = ""
instance_key    = ""
cluster_version = "1.30"
# check for the compatible version here: https://docs.aws.amazon.com/eks/latest/userguide/addon-compat.html
ebs_driver_version = "v1.34.0-eksbuild.1"
# if any kms encryption used, provide the arn here
kms_key_arn = ""
