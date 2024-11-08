/* AWS Load Balancer Controller IAM */
/* Ref: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html */

resource "aws_iam_policy" "aws_loadbalancer_controller_policy_part_one" {
  name = "AWSLoadBalancerControllerIAMPolicyPartOne"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateServiceLinkedRole"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : "elasticloadbalancing.amazonaws.com"
          },
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeCoipPools",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeListenerCertificates",
          "elasticloadbalancing:DescribeSSLPolicies",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTags"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cognito-idp:DescribeUserPoolClient",
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "iam:ListServerCertificates",
          "iam:GetServerCertificate",
          "waf-regional:GetWebACL",
          "waf-regional:GetWebACLForResource",
          "waf-regional:AssociateWebACL",
          "waf-regional:DisassociateWebACL",
          "wafv2:GetWebACL",
          "wafv2:GetWebACLForResource",
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "shield:GetSubscriptionState",
          "shield:DescribeProtection",
          "shield:CreateProtection",
          "shield:DeleteProtection"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateSecurityGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags"
        ],
        "Resource" : "arn:aws:ec2:*:*:security-group/*",
        "Condition" : {
          "StringEquals" : {
            "ec2:CreateAction" : "CreateSecurityGroup"
          },
          "Null" : {
            "aws:RequestTag/elbv2.k8s.aws/cluster" : "false",
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          },
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ],
        "Resource" : "arn:aws:ec2:*:*:security-group/*",
        "Condition" : {
          "Null" : {
            "aws:RequestTag/elbv2.k8s.aws/cluster" : "true",
            "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false",
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"

          },
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "aws_loadbalancer_controller_policy_part_two" {
  name = "AWSLoadBalancerControllerIAMPolicyPartTwo"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DeleteSecurityGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "Null" : {
            "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false",
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          },
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "Null" : {
            "aws:RequestTag/elbv2.k8s.aws/cluster" : "false",
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          },
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:DeleteRule"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ],
        "Resource" : [
          "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
        ],
        "Condition" : {
          "Null" : {
            "aws:RequestTag/elbv2.k8s.aws/cluster" : "true",
            "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false",
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          },
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags"
        ],
        "Resource" : [
          "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
        ],
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:SetIpAddressType",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:DeleteTargetGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false",
            "aws:ResourceTag/elbv2.k8s.aws/cluster" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:AddTags"
        ],
        "Resource" : [
          "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
        ],
        "Condition" : {
          "StringEquals" : {
            "elasticloadbalancing:CreateAction" : [
              "CreateTargetGroup",
              "CreateLoadBalancer"
            ]
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false",
            "aws:RequestTag/elbv2.k8s.aws/cluster" : "false"
          },
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        "Resource" : "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}"
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticloadbalancing:SetWebAcl",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:AddListenerCertificates",
          "elasticloadbalancing:RemoveListenerCertificates",
          "elasticloadbalancing:ModifyRule"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnEquals" : {
            "ec2:Vpc" : "arn:aws:ec2:${var.region}:${var.aws_account_id}:vpc/${var.vpc_id}",
          },
          "Null" : {
            "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}" : "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "aws_loadbalancer_controller_role" {
  depends_on = [aws_iam_policy.aws_loadbalancer_controller_policy_part_one, aws_iam_policy.aws_loadbalancer_controller_policy_part_two]
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

resource "aws_iam_role_policy_attachment" "aws_loadbalancer_role_attachment_one" {
  depends_on = [aws_iam_role.aws_loadbalancer_controller_role]
  role       = aws_iam_role.aws_loadbalancer_controller_role.name
  policy_arn = aws_iam_policy.aws_loadbalancer_controller_policy_part_one.arn
}

resource "aws_iam_role_policy_attachment" "aws_loadbalancer_role_attachment_two" {
  depends_on = [aws_iam_role.aws_loadbalancer_controller_role]
  role       = aws_iam_role.aws_loadbalancer_controller_role.name
  policy_arn = aws_iam_policy.aws_loadbalancer_controller_policy_part_two.arn
}


resource "kubernetes_service_account" "aws_load_balancer_controller_sa" {
  depends_on = [aws_iam_role_policy_attachment.aws_loadbalancer_role_attachment_one, aws_iam_role_policy_attachment.aws_loadbalancer_role_attachment_two]
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
