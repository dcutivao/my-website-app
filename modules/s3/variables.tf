variable "buckets" {
  type = map(object({
    versioning = bool
  }))
}

variable "environment" {
  description = "Nombre del entorno (ejemplo: dev, staging, prod)"
  type        = string
}
