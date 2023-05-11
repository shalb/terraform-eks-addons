resource "helm_release" "cert_manager" {
  count            = var.enable_cert_manager ? 1 : 0
  create_namespace = true
  namespace        = "cert-manager"
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version
  values = [
    "${file("${path.module}/values/cert-manager.yaml")}"
  ]
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_route53.iam_role_arn
  }
}

resource "kubernetes_manifest" "cluster_issuer_le_prod_dns01" {
  count = var.enable_cert_manager ? 1 : 0
  depends_on = [
    helm_release.cert_manager
  ]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        email = local.email
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        server = "https://acme-v02.api.letsencrypt.org/directory"
        solvers = [
          {
            dns01 = {
              route53 = {
                region = var.region
              }
            }
            selector = {
              dnsZones = [
                var.route53_domain,
              ]
            }
          },
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "cluster_issuer_le_staging_dns01" {
  count = var.enable_cert_manager ? 1 : 0
  depends_on = [
    helm_release.cert_manager
  ]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }
    spec = {
      acme = {
        email = local.email
        privateKeySecretRef = {
          name = "letsencrypt-staging"
        }
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        solvers = [
          {
            dns01 = {
              route53 = {
                region = var.region
              }
            }
            selector = {
              dnsZones = [
                var.route53_domain,
              ]
            }
          },
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "cluster_issuer_le_prod_http01" {
  count = var.enable_cert_manager ? 1 : 0
  depends_on = [
    helm_release.cert_manager
  ]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod-http"
    }
    spec = {
      acme = {
        email = local.email
        privateKeySecretRef = {
          name = "letsencrypt-prod-http"
        }
        server = "https://acme-v02.api.letsencrypt.org/directory"
        solvers = [
          {
            http01 = {
              ingress = {
                class = nginx
              }
            }
          },
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "cluster_issuer_le_staging_http01" {
  count = var.enable_cert_manager ? 1 : 0
  depends_on = [
    helm_release.cert_manager
  ]
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging-http"
    }
    spec = {
      acme = {
        email = local.email
        privateKeySecretRef = {
          name = "letsencrypt-staging-http"
        }
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        solvers = [
          {
            http01 = {
              ingress = {
                class = nginx
              }
            }
          },
        ]
      }
    }
  }
}
