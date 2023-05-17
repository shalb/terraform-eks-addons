# AWS EKS Terraform Module

Terraform module that install core addons in EKS cluster:

1. argocd
2. ingress-nginx
3. external-dns
4. cluster autoscaler
6. external-secrets
7. cert-manager
8. efs driver
9. aws lb controller


## Prerequisites

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.60.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.20.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.66.1 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.9.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_attach_load_balancer_controller_policy"></a> [attach\_load\_balancer\_controller\_policy](#module\_attach\_load\_balancer\_controller\_policy) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> v5.11 |
| <a name="module_iam_assumable_role_autoscaler"></a> [iam\_assumable\_role\_autoscaler](#module\_iam\_assumable\_role\_autoscaler) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 5.11 |
| <a name="module_iam_assumable_role_efs"></a> [iam\_assumable\_role\_efs](#module\_iam\_assumable\_role\_efs) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> v5.11 |
| <a name="module_iam_assumable_role_external_secrets"></a> [iam\_assumable\_role\_external\_secrets](#module\_iam\_assumable\_role\_external\_secrets) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> v5.11 |
| <a name="module_iam_assumable_role_route53"></a> [iam\_assumable\_role\_route53](#module\_iam\_assumable\_role\_route53) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 5.11 |
| <a name="module_iam_policy_autoscaler"></a> [iam\_policy\_autoscaler](#module\_iam\_policy\_autoscaler) | terraform-aws-modules/iam/aws//modules/iam-policy | ~> 5.11 |
| <a name="module_iam_policy_route53"></a> [iam\_policy\_route53](#module\_iam\_policy\_route53) | terraform-aws-modules/iam/aws//modules/iam-policy | ~> 5.11 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.aws_lb_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.efs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kubernetes_metrics_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.cluster_issuers](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.lb_delete_delay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_chart_version"></a> [argocd\_chart\_version](#input\_argocd\_chart\_version) | Argocd helm chart version | `string` | `"3.29.5"` | no |
| <a name="input_argocd_image_tag"></a> [argocd\_image\_tag](#input\_argocd\_image\_tag) | Argocd docker image version | `string` | `"v2.2.2"` | no |
| <a name="input_argocd_password_bcrypted"></a> [argocd\_password\_bcrypted](#input\_argocd\_password\_bcrypted) | Bctypted password (hash) for argocd web ui | `string` | `""` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Cert manager helm chart version | `string` | `"v1.5.4"` | no |
| <a name="input_cluster_autoscaler_version"></a> [cluster\_autoscaler\_version](#input\_cluster\_autoscaler\_version) | Cluster utoscaler helm chart version | `string` | `"9.27.0"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | The URL on the EKS cluster for the OpenID Connect identity provider | `string` | n/a | yes |
| <a name="input_cluster_oidc_provider_arn"></a> [cluster\_oidc\_provider\_arn](#input\_cluster\_oidc\_provider\_arn) | The ARN of the OIDC Provider if enable\_irsa = true | `string` | n/a | yes |
| <a name="input_cluster_subnets"></a> [cluster\_subnets](#input\_cluster\_subnets) | Subnets where EKS worker nodes are spawned. Required for ingress controller. | `list(any)` | `[]` | no |
| <a name="input_efs_id"></a> [efs\_id](#input\_efs\_id) | EFD FileSystem ID to use in efs drivers dynamyc storage class | `string` | `""` | no |
| <a name="input_email"></a> [email](#input\_email) | Organization email for LE issuers | `string` | `""` | no |
| <a name="input_enable_argocd"></a> [enable\_argocd](#input\_enable\_argocd) | Disable/enable ArgoCD addon | `bool` | `false` | no |
| <a name="input_enable_aws_lb_controller"></a> [enable\_aws\_lb\_controller](#input\_enable\_aws\_lb\_controller) | Disable/enable AWS LB controller | `bool` | `true` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Disable/enable cert manager | `bool` | `false` | no |
| <a name="input_enable_cert_manager_http_issuers"></a> [enable\_cert\_manager\_http\_issuers](#input\_enable\_cert\_manager\_http\_issuers) | Disable/enable cert manager http issuers | `bool` | `false` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | Disable/enable AWS cluster autoscaler | `bool` | `true` | no |
| <a name="input_enable_efs"></a> [enable\_efs](#input\_enable\_efs) | Disable/enable AWS EFS driver | `bool` | `false` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_dns](#input\_enable\_external\_dns) | Disable/enable external dns | `bool` | `true` | no |
| <a name="input_enable_external_secrets"></a> [enable\_external\_secrets](#input\_enable\_external\_secrets) | Disable/enable kubernetes external secrets addon | `bool` | `false` | no |
| <a name="input_enable_metrics_server"></a> [enable\_metrics\_server](#input\_enable\_metrics\_server) | Disable/enable Metric Server | `bool` | `false` | no |
| <a name="input_enable_nginx"></a> [enable\_nginx](#input\_enable\_nginx) | Disable/enable Nginx Ingress | `bool` | `false` | no |
| <a name="input_enable_reloader"></a> [enable\_reloader](#input\_enable\_reloader) | Disable/enable reloader | `bool` | `false` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | External dns helm chart version | `string` | `"6.5.6"` | no |
| <a name="input_external_secrets_version"></a> [external\_secrets\_version](#input\_external\_secrets\_version) | External secrets helm chart version | `string` | `"0.7.2"` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Ingress nginx helm chart version | `string` | `"4.2.5"` | no |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Metrics Server helm chart version | `string` | `"6.0.8"` | no |
| <a name="input_nginx_default_cert"></a> [nginx\_default\_cert](#input\_nginx\_default\_cert) | Define default ingress nginx cert in format namespace/certname, required for wildcard domains setup. | `string` | `"ingress-nginx/default"` | no |
| <a name="input_region"></a> [region](#input\_region) | EKS cluster region | `string` | n/a | yes |
| <a name="input_reloader_version"></a> [reloader\_version](#input\_reloader\_version) | Reloader chart version | `string` | `"v0.0.118"` | no |
| <a name="input_route53_domain"></a> [route53\_domain](#input\_route53\_domain) | DNS domain to create apps DNS records for applications | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | The id of the route53 to create apps DNS records (for external dns) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data_raw"></a> [cluster\_certificate\_authority\_data\_raw](#output\_cluster\_certificate\_authority\_data\_raw) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | The kubeconfig to use to authenticate with the cluster |
| <a name="output_kubeconfig_raw"></a> [kubeconfig\_raw](#output\_kubeconfig\_raw) | The kubeconfig to use to authenticate with the cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
