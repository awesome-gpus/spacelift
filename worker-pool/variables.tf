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

variable "worker_pool_config" {
  type        = string
  description = "Token for the worker pool"
  sensitive   = true
}

variable "worker_pool_private_key" {
  type        = string
  description = "privateKey of the worker pool"
  sensitive   = true
}