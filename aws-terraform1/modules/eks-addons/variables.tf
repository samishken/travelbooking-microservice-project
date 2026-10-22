variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "oidc_issuer" {
  description = "EKS Cluster OIDC Issuer URL"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_controller_chart_version" {
  description = "AWS Load Balancer Controller Helm chart version"
  type        = string
  default     = "3.6.1"
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
}

variable "domain_name" {
  description = "Root domain managed by ExternalDNS"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID managed by ExternalDNS"
  type        = string
}

variable "external_dns_chart_version" {
  description = "ExternalDNS Helm chart version"
  type        = string
  default     = "1.23.0"
}
