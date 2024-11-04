/* Nodegroup template module */

locals {
  common_tags = {
    "name"                                                    = var.name
    "aws:eks:cluster-name"                                    = var.common_config.cluster_name
    "kubernetes.io/cluster/${var.common_config.cluster_name}" = "owned"
  }

  autoscaler_tags = {
    "k8s.io/cluster-autoscaler/${var.common_config.cluster_name}" = "enabled"
    "k8s.io/cluster-autoscaler/enabled"                           = "true"
  }

  node_group_tags = var.autoscaler_enabled ? merge(local.common_tags, local.autoscaler_tags) : local.common_tags

}

resource "aws_eks_node_group" "node_group" {

  cluster_name    = var.common_config.cluster_name
  node_group_name = var.name
  capacity_type   = var.provision_type
  instance_types  = var.instance_types
  node_role_arn   = var.common_config.node_role_arn

  tags     = local.node_group_tags
  tags_all = local.node_group_tags

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  remote_access {
    ec2_ssh_key               = var.common_config.ec2_key
    source_security_group_ids = var.common_config.security_group_ids
  }

  dynamic "taint" {
    for_each = toset(var.node_group_taints)
    iterator = t
    content {
      key    = t.value.key
      value  = t.value.value
      effect = t.value.effect
    }
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, scaling_config[0].min_size, scaling_config[0].max_size, tags, tags_all]
  }

  subnet_ids = var.subnet_ids
}