resource "helm_release" "kubernetes_metrics_server" {
  count            = var.enable_metrics_server ? 1 : 0
  name             = "metrics-server"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "metrics-server"
  version          = var.metrics_server_version
  namespace        = "kube-system"
  create_namespace = false
  set {
    name  = "apiService.create"
    value = "true"
  }
  set {
    name  = "containerPorts.https"
    value = "4443"
  }
  set {
    name  = "extraArgs"
    value = "{--kubelet-insecure-tls=true,--kubelet-preferred-address-types=InternalIP}"
  }
}
