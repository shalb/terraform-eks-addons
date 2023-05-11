resource "helm_release" "argocd" {
  count            = var.enable_argocd ? 1 : 0
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = "argocd"
  create_namespace = true
  name             = "argocd"
  depends_on = [
    kubernetes_manifest.cluster_issuer_le_prod_dns01
  ]
  values = [
    "${file("${path.module}/values/argocd.yaml")}"
  ]
  set {
    name  = "server.config.url"
    value = "https://argocd.${var.route53_domain}"
  }
  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = "argocd.${var.route53_domain}"
  }
  set {
    name  = "server.certificate.domain"
    value = "argocd.${var.route53_domain}"
  }
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_password_bcrypted
  }
  set {
    name  = "server.ingress.hosts[0]"
    value = "argocd.${var.route53_domain}"
  }
  set {
    name  = "global.image.tag"
    value = var.argocd_image_tag
  }
}
