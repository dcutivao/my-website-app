variable "name_codepipeline" {
  type = string
}

variable "environment" {
  description = "Nombre del entorno (ejemplo: dev, staging, prod)"
  type        = string
}

variable "arn_role" {
  type = string
}

variable "all_bucket_id" {
  type = list(string)
}