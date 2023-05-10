resource "helm_release" "external_dns" {
  count            = var.enable_external_dns ? 1 : 0
  create_namespace = true
  namespace        = "external-dns"
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  version          = var.external_dns_version
  values = [
    "${file("${path.module}/values/external-dns.yaml")}"
  ]
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_route53.iam_role_arn
  }
  set {
    name  = "aws.region"
    value = var.region
  }
  set {
    name  = "domainFilters[0]"
    value = var.route53_domain
  }
  set {
    name  = "aws.zoneType"
    value = "public"
  }
}

module "iam_policy_route53" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.11"
  name    = "AllowExternalDNSUpdates-${var.cluster_name}"
  policy  = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "route53:ChangeResourceRecordSets",
          "route53:GetChange"
        ],
        "Resource": [
          "arn:aws:route53:::hostedzone/${var.route53_zone_id}",
          "arn:aws:route53:::change/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZonesByName"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }
  EOT
}

module "iam_assumable_role_route53" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "~> 5.11"
  create_role = true
  role_policy_arns = [
    module.iam_policy_route53.arn
  ]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:external-dns:external-dns",
    "system:serviceaccount:cert-manager:cert-manager"
  ]
  provider_url = var.cluster_oidc_issuer_url
  role_name    = "eks-route53-${var.cluster_name}"
}
