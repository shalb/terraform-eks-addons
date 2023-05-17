locals {
  email = var.email == "" ? "devops@${var.route53_domain}" : ""
  efs_driver_images_map = {
    af-south-1     = "877085696533.dkr.ecr.af-south-1.amazonaws.com",
    ap-east-1      = "800184023465.dkr.ecr.ap-east-1.amazonaws.com",
    ap-northeast-1 = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com",
    ap-northeast-2 = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com",
    ap-northeast-3 = "602401143452.dkr.ecr.ap-northeast-3.amazonaws.com",
    ap-south-1     = "602401143452.dkr.ecr.ap-south-1.amazonaws.com",
    ap-southeast-1 = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com",
    ap-southeast-2 = "602401143452.dkr.ecr.ap-southeast-2.amazonaws.com",
    ap-southeast-3 = "296578399912.dkr.ecr.ap-southeast-3.amazonaws.com",
    ca-central-1   = "602401143452.dkr.ecr.ca-central-1.amazonaws.com",
    cn-north-1     = "918309763551.dkr.ecr.cn-north-1.amazonaws.com",
    cn-northwest-1 = "961992271922.dkr.ecr.cn-northwest-1.amazonaws.com",
    eu-central-1   = "602401143452.dkr.ecr.eu-central-1.amazonaws.com",
    eu-north-1     = "602401143452.dkr.ecr.eu-north-1.amazonaws.com",
    eu-south-1     = "590381155156.dkr.ecr.eu-south-1.amazonaws.com",
    eu-west-1      = "602401143452.dkr.ecr.eu-west-1.amazonaws.com",
    eu-west-2      = "602401143452.dkr.ecr.eu-west-2.amazonaws.com",
    eu-west-3      = "602401143452.dkr.ecr.eu-west-3.amazonaws.com",
    me-south-1     = "558608220178.dkr.ecr.me-south-1.amazonaws.com",
    sa-east-1      = "602401143452.dkr.ecr.sa-east-1.amazonaws.com",
    us-east-1      = "602401143452.dkr.ecr.us-east-1.amazonaws.com",
    us-east-2      = "602401143452.dkr.ecr.us-east-2.amazonaws.com",
    us-gov-east-1  = "151742754352.dkr.ecr.us-gov-east-1.amazonaws.com",
    us-gov-west-1  = "013241004608.dkr.ecr.us-gov-west-1.amazonaws.com",
    us-west-1      = "602401143452.dkr.ecr.us-west-1.amazonaws.com",
    us-west-2      = "602401143452.dkr.ecr.us-west-2.amazonaws.com"
  } # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  aws_image_registry = local.efs_driver_images_map[var.region]

  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = var.cluster_name
      cluster = {
        certificate-authority-data = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
        server                     = data.aws_eks_cluster.cluster.endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = var.cluster_name
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        exec = {
          apiVersion = "client.authentication.k8s.io/v1beta1"
          args       = ["eks", "get-token", "--cluster-name", var.cluster_name]
          command    = "aws"
        }
      }
    }]
  })
  kubeconfig_base64 = base64encode(local.kubeconfig)
}
