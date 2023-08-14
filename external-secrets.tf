resource "helm_release" "external_secrets" {
  count        = var.enable_external_secrets ? 1 : 0
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.external_secrets_version
  create_namespace = true
  namespace        = "external-secrets"

  values = [templatefile("${path.module}/values/external-secrets.yaml", {
    secret_operator_role = module.iam_assumable_role_external_secrets[0].iam_role_arn
  })]
}

module "iam_assumable_role_external_secrets" {
  count        = var.enable_external_secrets ? 1 : 0
  source       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version      = "~> v5.11"
  create_role  = true
  role_name    = "eks-external-secrets-${random_id.id.hex}-${var.cluster_name}"
  provider_url = var.cluster_oidc_issuer_url
  role_policy_arns = [
    aws_iam_policy.external_secrets[0].arn
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-secrets:external-secrets"]
}

resource "aws_iam_policy" "external_secrets" {
  count  = var.enable_external_secrets ? 1 : 0
  name   = "AllowExternalSecrets-${random_id.id.hex}-${var.cluster_name}"
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "arn:aws:secretsmanager:${var.region}:*:secret:*"
      ]
    }
  ]
}
  EOF
}
