provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

# =============================================
# EKS Authentication
# Uses module outputs + exec token so the providers stay configured
# even when the cluster itself has pending in-place changes.
# =============================================
locals {
  eks_exec_args = [
    "eks", "get-token",
    "--cluster-name", module.eks.cluster_name,
    "--region", var.aws_region,
    "--profile", var.aws_profile,
  ]
}

# Kubernetes Provider
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = local.eks_exec_args
  }
}

# Helm Provider
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = local.eks_exec_args
    }
  }
}
