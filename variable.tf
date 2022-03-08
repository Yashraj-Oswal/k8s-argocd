variable "kind_config-path" {
  type        = string
  description = "Kubernetes config path"
  default     = "~/.kube/config"
}

variable "ingress_nginx_helm_version" {
  type        = string
  description = "Helm version for ingress nginx controller"
  default     = "4.0.18"
}

variable "argocd_namespace" {
  type        = string
  description = "Name of argocd namespace"
  default     = "argocd"
}

variable "nginx_namespace" {
  type        = string
  description = "Name of the nginx namespace"
  default     = "ingress-nginx"
}

