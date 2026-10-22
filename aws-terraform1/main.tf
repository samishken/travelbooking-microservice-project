##############################################
# VPC
##############################################
module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

##############################################
# Security Groups
##############################################
module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "elastic-ip" {
  source = "./modules/elastic-ip"
  name   = var.elastic_ip_name
}

##############################################
# IAM
##############################################
module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
  tags         = var.tags
}

##############################################
# Amazon EKS
##############################################
module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  subnet_ids         = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  cluster_role_arn   = module.iam.cluster_role_arn
  node_role_arn      = module.iam.node_role_arn
  node_group_name    = var.node_group_name
  instance_type      = var.instance_type
  desired_size       = var.desired_size
  min_size           = var.min_size
  max_size           = var.max_size
  disk_size          = var.disk_size
  cluster_admin_arns = var.cluster_admin_arns
  tags               = var.tags
}

##############################################
# EKS Add-ons (OIDC, EBS CSI, ALB Controller)
##############################################
module "eks-addons" {
  source         = "./modules/eks-addons"
  cluster_name   = module.eks.cluster_name
  oidc_issuer    = module.eks.oidc_issuer
  aws_region     = var.aws_region
  vpc_id         = module.vpc.vpc_id
  domain_name    = var.domain_name
  hosted_zone_id = module.dns.zone_id
  tags           = var.tags

  depends_on = [module.eks]
}

##############################################
# Route 53 Hosted Zone
##############################################
module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name
  tags        = var.tags
}

##############################################
# ACM Certificate (HTTPS for the ALB)
##############################################
module "acm" {
  count          = var.enable_https ? 1 : 0
  source         = "./modules/acm"
  domain_name    = var.domain_name
  hosted_zone_id = module.dns.zone_id
  tags           = var.tags
}

##############################################
# Amazon ECR
##############################################
module "ecr" {
  source       = "./modules/ecr"
  repositories = var.ecr_repositories
  tags         = var.tags
}


