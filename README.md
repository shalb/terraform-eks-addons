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
| terraform | >= 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| helm | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| argocd\_chart\_version | Argocd helm chart version | `string` | `"3.29.5"` | no |
| argocd\_image\_tag | Argocd docker image version | `string` | `"v2.2.2"` | no |
| argocd\_password\_bcrypted | Bctypted password (hash) for argocd web ui | `string` | `""` | no |
| cert\_manager\_version | Cert manager helm chart version | `string` | `"v1.5.4"` | no |
| cluster\_autoscaler\_version | Cluster utoscaler helm chart version | `string` | `"9.27.0"` | no |
| cluster\_name | EKS cluster name | `string` | n/a | yes |
| cluster\_oidc\_issuer\_url | The URL on the EKS cluster for the OpenID Connect identity provider | `string` | n/a | yes |
| cluster\_oidc\_provider\_arn | The ARN of the OIDC Provider if enable\_irsa = true | `string` | n/a | yes |
| cluster\_subnets | Subnets where EKS worker nodes are spawned. Required for ingress controller. | `list(any)` | `[]` | no |
| efs\_id | EFD FileSystem ID to use in efs drivers dynamyc storage class | `string` | `""` | no |
| email | Organization email for LE issuers | `string` | `""` | no |
| enable\_argocd | Disable/enable ArgoCD addon | `bool` | `false` | no |
| enable\_aws\_lb\_controller | Disable/enable AWS LB controller | `bool` | `true` | no |
| enable\_cert\_manager | Disable/enable cert manager | `bool` | `false` | no |
| enable\_cert\_manager\_http\_issuers | Disable/enable cert manager http issuers | `bool` | `false` | no |
| enable\_cluster\_autoscaler | Disable/enable AWS cluster autoscaler | `bool` | `true` | no |
| enable\_efs | Disable/enable AWS EFS driver | `bool` | `false` | no |
| enable\_external\_dns | Disable/enable external dns | `bool` | `true` | no |
| enable\_external\_secrets | Disable/enable kubernetes external secrets addon | `bool` | `false` | no |
| enable\_metrics\_server | Disable/enable Metric Server | `bool` | `false` | no |
| enable\_nginx | Disable/enable Nginx Ingress | `bool` | `false` | no |
| enable\_reloader | Disable/enable reloader | `bool` | `false` | no |
| external\_dns\_version | External dns helm chart version | `string` | `"6.5.6"` | no |
| external\_secrets\_version | External secrets helm chart version | `string` | `"0.7.2"` | no |
| ingress\_nginx\_version | Ingress nginx helm chart version | `string` | `"4.2.5"` | no |
| metrics\_server\_version | Metrics Server helm chart version | `string` | `"6.0.8"` | no |
| nginx\_default\_cert | Define default ingress nginx cert in format namespace/certname, required for wildcard domains setup. | `string` | `"ingress-nginx/default"` | no |
| region | EKS cluster region | `string` | n/a | yes |
| reloader\_version | Reloader chart version | `string` | `"v0.0.118"` | no |
| route53\_domain | DNS domain to create apps DNS records for applications | `string` | n/a | yes |
| route53\_zone\_id | The id of the route53 to create apps DNS records (for external dns) | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
