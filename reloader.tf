resource "helm_release" "reloader" {
  count            = var.enable_reloader ? 1 : 0
  name             = "reloader"
  repository       = "https://stakater.github.io/stakater-charts"
  chart            = "reloader"
  version          = var.reloader_version
  namespace        = "external-secrets"
  create_namespace = true
  force_update     = true
  set {
    name  = "global.imagePullSecrets[0].name"
    value = "regcred"
  }

}
