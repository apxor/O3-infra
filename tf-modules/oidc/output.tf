output "oidc_id" {
  value = local.oidc_id
}

output "aws_iam_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.provider.arn
}

output "identity-oidc-issuer" {
  value = data.aws_eks_cluster.eks_info.identity[0].oidc[0].issuer
}
