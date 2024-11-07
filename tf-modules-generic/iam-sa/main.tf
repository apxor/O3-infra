/* 
Ref: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

This module is to create kubernetes service account and associate it required IAM roles.
    This is to provide authentication for kubernetes pods using this service account to access AWS services.
*/

/* creating policy statement based on input access request */
locals {
  buckets_statement = var.access_to_s3_buckets != null ? tolist([
    for bucket in var.access_to_s3_buckets :
    {
      "Effect" : "Allow",
      "Action" : tolist([
        "s3:*"
      ]),
      "Resource" : tolist([
        "arn:aws:s3:::${bucket}",
        "arn:aws:s3:::${bucket}/*"
      ])
    }
  ]) : tolist([])

  full_statement = concat(local.buckets_statement)
  need_iam       = length(local.full_statement) > 0 ? true : false
}

resource "aws_iam_policy" "kube_sa_iam_policy" {
  count = local.need_iam ? 1 : 0
  name  = "apx-o3-${var.environment}-${var.service_account_name}-${var.namespace}-sa-IAM-Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : local.full_statement
  })
}

resource "aws_iam_role" "kube_sa_iam_role" {
  depends_on = [aws_iam_policy.kube_sa_iam_policy]
  count      = local.need_iam ? 1 : 0
  name       = "apx-o3-${var.environment}-${var.service_account_name}-${var.namespace}-sa-IAM-Role"
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
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:sub" : "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kube_role_policy_attachment" {
  count      = local.need_iam ? 1 : 0
  depends_on = [aws_iam_role.kube_sa_iam_role]
  role       = aws_iam_role.kube_sa_iam_role[0].name
  policy_arn = aws_iam_policy.kube_sa_iam_policy[0].arn
}


resource "kubernetes_service_account" "kube_service_account_with_iam" {
  depends_on = [aws_iam_role_policy_attachment.kube_role_policy_attachment]
  count      = local.need_iam ? 1 : 0
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/name"       = "${var.service_account_name}"
      "app.kubernetes.io/managed-by" = "Terraform"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.aws_account_id}:role/${aws_iam_role.kube_sa_iam_role[0].name}"
    }
  }
}
