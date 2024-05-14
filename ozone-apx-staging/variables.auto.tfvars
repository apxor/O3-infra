/* Variables for AWS environemnt */

region         = ""
environment    = ""
aws_account_id = ""
sso_profile    = ""

/* Variables for Networking module */

vpc_cidr             = "10.0.0.0/16"
private_subnets_cidr = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
public_subnets_cidr  = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]

/* Variables for EKS */

cluster_name    = ""
cluster_version = ""
instance_key    = ""
