/* IAM for driver */
/* Ref: https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html */


resource "aws_iam_role" "eks_ebs_csi_driver_role" {
  name = "${var.environment}-AmazonEKS_EBS_CSI_DriverRole"
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
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_ebs_policy_attachment" {
  depends_on = [aws_iam_role.eks_ebs_csi_driver_role]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_ebs_csi_driver_role.name
}


/* KMS key policy for EBS CSI driver */

resource "aws_iam_policy" "ebs_csi_driver_kms_key" {
  count       = var.kms_key_arn != "" ? 1 : 0
  description = "KMS key for EBS CSI driver"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource" : ["${var.kms_key_arn}"],
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : ["${var.kms_key_arn}"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_kms_key_attachment" {
  count      = var.kms_key_arn != "" ? 1 : 0
  role       = aws_iam_role.eks_ebs_csi_driver_role.name
  policy_arn = aws_iam_policy.ebs_csi_driver_kms_key[0].arn
}
