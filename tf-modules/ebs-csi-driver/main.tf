/* Module to deploy Amazon Elastic Block Store CSI driver */
/* Ref: https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html */

/* deploy ebs add on using terraform aws_eks_addon resource */

resource "aws_eks_addon" "eks_ebs_driver" {
  count                       = var.enabled ? 1 : 0
  depends_on                  = [aws_iam_role_policy_attachment.eks_ebs_policy_attachment]
  cluster_name                = var.cluster_name
  addon_name                  = var.ebs_driver_name
  service_account_role_arn    = aws_iam_role.eks_ebs_csi_driver_role.arn
  resolve_conflicts_on_create = "OVERWRITE"
  addon_version               = var.ebs_driver_version
  configuration_values = jsonencode({
    sidecars = {
      snapshotter = {
        forceEnable = var.ebs_snapshotter_force_enable
      }
    }
  })
}
