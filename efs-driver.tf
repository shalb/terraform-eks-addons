resource "helm_release" "efs" {
  count            = var.enable_efs ? 1 : 0
  create_namespace = true
  namespace        = "kube-system"
  name             = "aws-efs-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart            = "aws-efs-csi-driver"
  version          = "2.2.7"

  values = [
    templatefile("${path.module}/templates/efs-driver.yaml", { efs_id = var.efs_id })
  ]

  set {
    name  = "image.repository"
    value = "${local.aws_image_registry}/eks/aws-efs-csi-driver"
  }
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_efs[0].iam_role_arn
  }
}


module "iam_assumable_role_efs" {
  count        = var.enable_efs ? 1 : 0
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "~> v5.11"
  create_role  = true
  role_name    = "eks-efs-${random_id.id.hex}-${var.cluster_name}"
  provider_url = var.cluster_oidc_issuer_url
  role_policy_arns = [
    aws_iam_policy.efs[0].arn
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
}

resource "aws_iam_policy" "efs" {
  count  = var.enable_efs ? 1 : 0
  name   = "AllowEFS-${random_id.id.hex}-${var.cluster_name}"
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:DescribeMountTargets",
        "ec2:DescribeAvailabilityZones"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:CreateAccessPoint"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/efs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "elasticfilesystem:DeleteAccessPoint",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
  EOF
}
