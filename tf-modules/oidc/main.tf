/* IAM OIDC provider for EKS cluster */
/* Ref: https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html */

data "aws_eks_cluster" "eks_info" {
  name = var.cluster_name
}



locals {
  oidc_id = basename(data.aws_eks_cluster.eks_info.identity[0].oidc[0].issuer)
}


data "tls_certificate" "eks_tlscertificate" {
  url = data.aws_eks_cluster.eks_info.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.eks_tlscertificate.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.eks_tlscertificate.url
}

locals {
  oidc_identity_provider_url = "oidc-provider/oidc.eks.${data.aws_eks_cluster.eks_info.endpoint}.amazonaws.com"
  original_url               = data.aws_eks_cluster.eks_info.identity[0].oidc[0].issuer
}

locals {
  id_from_url = basename(data.aws_eks_cluster.eks_info.identity[0].oidc[0].issuer)
}
