variable "environment" {
  description = "Nombre del entorno (ejemplo: dev, staging, prod)"
  type        = string
}

variable "buckets" {
  type = map(object({
    versioning = bool
  }))
  default = {
    "web-origen" = { versioning = true }
    #"artefact"       = { versioning = false }
    "web-produccion"  = { versioning = false }
  }
}

/* variable "name_codepipeline" {
  type = string
} */