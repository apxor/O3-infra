/* Cluster Autoscaler IAM */
/* Ref: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md */


resource "aws_iam_policy" "autoscaling_policy" {
  name        = "${var.environment}-AWSEKSNodeAutoscaling"
  description = "Policy for EKS node autoscaling"
  policy      = file("${path.module}/resources/auto_scaling_policy.json")
}

resource "aws_iam_role" "eks_node_autoscaling_role" {
  depends_on = [aws_iam_policy.autoscaling_policy]
  name       = "${var.environment}-AWSEKSNodeAutoscalingRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${var.aws_iam_oidc_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_autoscaling_policy_attachment" {
  depends_on = [aws_iam_role.eks_node_autoscaling_role]
  policy_arn = aws_iam_policy.autoscaling_policy.arn
  role       = aws_iam_role.eks_node_autoscaling_role.name
}
