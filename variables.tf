variable "argocd_chart_version" {
  type        = string
  default     = "3.29.5"
  description = "Argocd helm chart version"
}

variable "argocd_image_tag" {
  type        = string
  default     = "v2.2.2"
  description = "Argocd docker image version"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
}

variable "cluster_oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if enable_irsa = true"
  type        = string
}

variable "cluster_kubeconfig" {
  type        = string
  description = "EKS cluster kubeconfig base64 encoded"
}

variable "cluster_subnets" {
  type        = list(any)
  default     = []
  description = "Subnets where EKS worker nodes are spawned. Required for ingress controller."
}

variable "route53_zone_id" {
  type        = string
  description = "The id of the route53 to create apps DNS records (for external dns)"
}

variable "route53_domain" {
  type        = string
  description = "DNS domain to create apps DNS records for applications"
}

variable "argocd_password_bcrypted" {
  type        = string
  description = "Bctypted password (hash) for argocd web ui"
  default     = ""
}

variable "region" {
  type        = string
  description = "EKS cluster region"
}

variable "enable_nginx" {
  type        = bool
  default     = false
  description = "Disable/enable Nginx Ingress"
}

variable "nginx_default_cert" {
  type        = string
  default     = "ingress-nginx/default"
  description = "Define default ingress nginx cert in format namespace/certname, required for wildcard domains setup."
}

variable "enable_argocd" {
  type        = bool
  default     = false
  description = "Disable/enable ArgoCD addon"
}

variable "enable_external_secrets" {
  type        = bool
  default     = false
  description = "Disable/enable kubernetes external secrets addon"
}

variable "enable_cluster_autoscaler" {
  type        = bool
  default     = true
  description = "Disable/enable AWS cluster autoscaler"
}
variable "enable_aws_lb_controller" {
  type        = bool
  default     = true
  description = "Disable/enable AWS LB controller"
}

variable "enable_external_dns" {
  type        = bool
  default     = true
  description = "Disable/enable external dns"
}

variable "enable_cert_manager" {
  type        = bool
  default     = false
  description = "Disable/enable cert manager"
}

variable "enable_cert_manager_http_issuers" {
  type        = bool
  default     = false
  description = "Disable/enable cert manager http issuers"
}

variable "enable_efs" {
  type        = bool
  default     = false
  description = "Disable/enable AWS EFS driver"
}

variable "cert_manager_version" {
  type        = string
  default     = "v1.5.4"
  description = "Cert manager helm chart version"
}

variable "ingress_nginx_version" {
  type        = string
  default     = "4.2.5"
  description = "Ingress nginx helm chart version"
}

variable "external_secrets_version" {
  type        = string
  default     = "0.7.2"
  description = "External secrets helm chart version"
}

variable "cluster_autoscaler_version" {
  type        = string
  default     = "9.27.0"
  description = "Cluster utoscaler helm chart version"
}

variable "external_dns_version" {
  type        = string
  default     = "6.5.6"
  description = "External dns helm chart version"
}

variable "efs_id" {
  type        = string
  default     = ""
  description = "EFD FileSystem ID to use in efs drivers dynamyc storage class"
}

variable "metrics_server_version" {
  type        = string
  default     = "6.0.8"
  description = "Metrics Server helm chart version"
}

variable "enable_metrics_server" {
  type        = bool
  default     = false
  description = "Disable/enable Metric Server"
}

variable "enable_reloader" {
  type        = bool
  default     = false
  description = "Disable/enable reloader"
}

variable "reloader_version" {
  type        = string
  default     = "v0.0.118"
  description = "Reloader chart version"
}

variable "email" {
  type        = string
  description = "Organization email for LE issuers"
  default     = ""
}
