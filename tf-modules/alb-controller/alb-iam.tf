/* AWS Load Balancer Controller IAM */
/* Ref: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html */

resource "aws_iam_policy" "aws_loadbalancer_controller_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/resources/alb_controller_iam_policy.json")
}

resource "aws_iam_role" "aws_loadbalancer_controller_role" {
  depends_on = [aws_iam_policy.aws_loadbalancer_controller_policy]
  name       = "AmazonEKSLoadBalancerControllerRole"
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
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:aud" : "sts.amazonaws.com",
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_loadbalancer_role_attachment" {
  depends_on = [aws_iam_role.aws_loadbalancer_controller_role]
  role       = aws_iam_role.aws_loadbalancer_controller_role.name
  policy_arn = aws_iam_policy.aws_loadbalancer_controller_policy.arn
}


resource "kubernetes_service_account" "aws_load_balancer_controller_sa" {
  depends_on = [aws_iam_role_policy_attachment.aws_loadbalancer_role_attachment]
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.aws_account_id}:role/${aws_iam_role.aws_loadbalancer_controller_role.name}"
    }
  }
}
