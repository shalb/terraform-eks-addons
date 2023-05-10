resource "helm_release" "cert_manager" {
  count            = var.enable_cert_manager ? 1 : 0
  create_namespace = true
  namespace        = "cert-manager"
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version # "v1.5.4"
  values = [
    "${file("${path.module}/values/cert-manager.yaml")}"
  ]
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_route53.iam_role_arn
  }
}



resource "null_resource" "cluster_issuers" {
  count = var.enable_cert_manager ? 1 : 0
  depends_on = [
    helm_release.cert_manager
  ]
  triggers = {
    kubeconfig = var.cluster_kubeconfig
    manifest = templatefile("${path.module}/templates/issuers.yaml", {
      email                             = local.email,
      region                            = var.region,
      enable_http                       = var.enable_cert_manager_http_issuers,
      main_route53_zone                 = var.route53_domain,
      enable_generated_domain_solver    = var.route53_generated_domain == "" ? false : true,
      route53_generated_domain          = var.route53_generated_domain,
      route53_generated_accessKeyID     = var.route53_generated_accessKeyID,
      route53_generated_secretAccessKey = var.route53_generated_secretAccessKey,
    })
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = var.cluster_kubeconfig
    }
    command = "echo \"${self.triggers.manifest}\" | kubectl apply --kubeconfig <(echo $KUBECONFIG | base64 -d) -f -"
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
    command = "echo \"${self.triggers.manifest}\" | kubectl delete --kubeconfig <(echo $KUBECONFIG | base64 -d) -f -"
  }
}
