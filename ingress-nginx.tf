resource "null_resource" "lb_delete_delay" {
  count = var.enable_nginx ? 1 : 0
  depends_on = [
    helm_release.aws_lb_controller
  ]
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/sh", "-c"]
    command     = "echo Wait && sleep 60"
  }
}


resource "helm_release" "ingress_nginx" {
  count            = var.enable_nginx ? 1 : 0
  chart            = "ingress-nginx"
  version          = var.ingress_nginx_version
  namespace        = "ingress-nginx"
  create_namespace = true
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  depends_on = [
    null_resource.lb_delete_delay
  ]
  values = [
    file("${path.module}/values/ingress-nginx.yaml")
  ]
  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = var.nginx_default_cert
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-subnets"
    value = tostring(join("\\,", var.cluster_subnets))
  }
}
