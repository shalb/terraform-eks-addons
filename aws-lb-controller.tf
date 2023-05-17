resource "helm_release" "aws_lb_controller" {
  count            = var.enable_aws_lb_controller ? 1 : 0
  create_namespace = true
  namespace        = "kube-system"
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = "1.4.4"
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.attach_load_balancer_controller_policy[0].iam_role_arn
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}

module "attach_load_balancer_controller_policy" {
  count   = var.enable_aws_lb_controller ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> v5.11"

  role_name = "aws-load-balancer-controller-${random_id.id.hex}-${var.cluster_name}"

  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
