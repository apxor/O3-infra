/*
 Reference: https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up.html
*/

module "apx-spark-bucket" {
  source      = "../s3-bucket"
  bucket_name = var.emr_bucket
}

locals {
  tags = {
    "created_by"   = "terraform"
    "cluster_name" = var.eks_cluster_name
  }
}

resource "aws_iam_role" "job_execution_role" {
  name        = "EKS-${var.eks_cluster_name}-EMRJobExecutionRole"
  description = "Emr job execution role for cluster ${var.eks_cluster_name}"
  tags        = local.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "job_execution_role_policy" {
  name = "job_execution_role_policy"
  role = aws_iam_role.job_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.emr_bucket}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}

# TODO Replace this resource once the provider is available for aws emr-containers
resource "null_resource" "update_trust_policy" {
  for_each = toset(var.eks_namespaces)

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    environment = {
      AWS_DEFAULT_REGION = var.aws_region
    }
    command = <<EOF
set -e

aws emr-containers update-role-trust-policy \
--cluster-name ${var.eks_cluster_name} \
--namespace ${each.value} \
--role-name ${aws_iam_role.job_execution_role.name} --profile ${var.sso_profile} \

EOF
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [aws_iam_role.job_execution_role]
}

/*
  virtual cluster for each namespace with name of the s"$cluster-$namespace"
*/
resource "aws_emrcontainers_virtual_cluster" "emr_cluster" {
  for_each = toset(var.eks_namespaces)
  name     = "eks-${var.eks_cluster_name}-${each.value}"
  tags     = local.tags
  container_provider {
    id   = var.eks_cluster_name
    type = "EKS"
    info {
      eks_info {
        namespace = each.value
      }
    }
  }
}
