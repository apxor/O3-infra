/* Variables for AWS environemnt */

region         = "ap-south-1"
environment    = ""
aws_account_id = ""
sso_profile    = "default"

/* Variables for Networking module */

vpc_cidr             = "10.0.0.0/16"
private_subnets_cidr = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
public_subnets_cidr  = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]

/* Variables for EKS */

cluster_name    = ""
instance_key    = ""
cluster_version = "1.30"
# check for the compatible version here: https://docs.aws.amazon.com/eks/latest/userguide/addon-compat.html
ebs_driver_version = "v1.34.0-eksbuild.1"

/* Variables for Nuding EKS. cluster version, driver version are taken from above */

nudging_cluster_name = ""