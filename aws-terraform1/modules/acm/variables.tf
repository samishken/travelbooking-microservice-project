variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 Hosted Zone ID"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
}
