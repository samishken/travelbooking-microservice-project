variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "tags" {
  description = "Common Tags"
  type        = map(string)
}
