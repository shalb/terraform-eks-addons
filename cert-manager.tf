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
    manifest = templatefile("${path.module}/templates/issuers.yaml", {
      email             = local.email,
      region            = var.region,
      enable_http       = var.enable_cert_manager_http_issuers,
      main_route53_zone = var.route53_domain,
    })
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBE_HOST      = data.aws_eks_cluster.cluster.endpoint
      CA_CERTIFICATE = data.aws_eks_cluster.cluster.certificate_authority[0].data
      TOKEN          = data.aws_eks_cluster_auth.cluster.token
    }
    command = "echo \"${self.triggers.manifest}\" | kubectl apply -s $KUBE_HOST --token $TOKEN --certificate-authority $(echo $CA_CERTIFICATE | base64 -d > /tmp/ca0011; echo /tmp/ca0011) -f -"
  }
    provisioner "local-exec" {
      when        = destroy
      interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBE_HOST      = data.aws_eks_cluster.cluster.endpoint
      CA_CERTIFICATE = data.aws_eks_cluster.cluster.certificate_authority[0].data
      TOKEN          = data.aws_eks_cluster_auth.cluster.token
    }
      command = "echo \"${self.triggers.manifest}\" | kubectl delete -s $KUBE_HOST --token $TOKEN --certificate-authority $(echo $CA_CERTIFICATE | base64 -d > /tmp/ca0011; echo /tmp/ca0011) -f -"
    }
}
