resource "helm_release" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  namespace  = "kube-system"
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_version
  values = [
    "${file("${path.module}/values/cluster-autoscaler.yaml")}"
  ]

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_autoscaler[0].iam_role_arn
  }
  set {
    name  = "awsRegion"
    value = var.region
  }
}

module "iam_policy_autoscaler" {
  count   = var.enable_cluster_autoscaler ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.11"
  name    = "ClusterAutoScaler-${var.cluster_name}"
  policy  = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeInstanceTypes"
        ],
        "Resource": "*"
      }
    ]
  }
  EOT
}

module "iam_assumable_role_autoscaler" {
  count       = var.enable_cluster_autoscaler ? 1 : 0
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "~> 5.11"
  create_role = true
  role_policy_arns = [
    module.iam_policy_autoscaler[0].arn
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"]
  provider_url                  = var.cluster_oidc_issuer_url
  role_name                     = "eks-autoscaler-${var.cluster_name}"
}
