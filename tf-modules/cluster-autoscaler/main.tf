/* Kubernetes Cluster Autoscaler for AWS */
/* Ref: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md */
/* Ref: https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler */


/* Cluster Autoscaler Deployment using Helm Chart */

resource "helm_release" "cluster_autoscaler" {
  count            = var.enabled ? 1 : 0
  chart            = var.helm_chart_name
  create_namespace = var.create_namespace
  namespace        = var.namespace
  name             = var.helm_release_name
  version          = var.helm_chart_version
  repository       = var.helm_repo_url

  set {
    name  = "cloudProvider"
    value = "aws"
  }
  set {
    name  = "awsRegion"
    value = var.region
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "autoDiscovery.enabled"
    value = var.auto_discovery_enabled
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${var.aws_account_id}:role/${aws_iam_role.eks_node_autoscaling_role.name}"
  }

  depends_on = [aws_iam_role_policy_attachment.eks_node_autoscaling_policy_attachment]
}
