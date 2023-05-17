terraform {
  required_version = ">= 1.2.0"
  required_providers {
    kubernetes = {
      version = ">= 2.20.0"
    }
    helm = {
      version = ">= 2.9.0"
    }
    aws = {
      version = ">= 4.60.0"
    }
    null = {
      version = ">= 3.2.0"
    }
    random = {
      version = ">= 3.0.0"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}
