variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_certificate_authority_data" {
  type        = string
  description = "EKS cluster CA data"
}
