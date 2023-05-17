output "kubeconfig" {
  description = "The kubeconfig to use to authenticate with the cluster"
  value       = local.kubeconfig_base64
}

output "kubeconfig_raw" {
  description = "The kubeconfig to use to authenticate with the cluster"
  value       = local.kubeconfig
}


output "cluster_certificate_authority_data_raw" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = base64decode(module.eks.cluster_certificate_authority_data)
}
