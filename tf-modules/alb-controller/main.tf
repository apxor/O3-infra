/* AWS Load Balancer Controller */
/* Ref: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html */
/* https://medium.com/@StephenKanyiW/provision-eks-with-terraform-helm-and-a-load-balancer-controller-821dacb35066 */

resource "helm_release" "alb-controller" {
  name            = var.helm_chart_name
  count           = var.enabled ? 1 : 0
  repository      = var.helm_chart_repo
  chart           = var.helm_chart_name
  namespace       = kubernetes_service_account.aws_load_balancer_controller_sa.metadata[0].namespace
  depends_on      = [kubernetes_service_account.aws_load_balancer_controller_sa]
  cleanup_on_fail = true

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws_load_balancer_controller_sa.metadata[0].name
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}
