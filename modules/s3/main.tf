
resource "random_string" "storageaccount-name" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets
  bucket   = "${each.key}-${random_string.storageaccount-name.result}"
  tags = {
    environment = var.environment
    Terraform   = "true"
  }
}


resource "aws_s3_bucket_versioning" "buckets_versioning" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.buckets[each.key].id

  versioning_configuration {
    status = each.value.versioning ? "Enabled" : "Suspended"                  # operador ternario: Si es true, devuelve "Enabled", Si es false, devuelve "Suspended".
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_dueno_objetos" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.buckets[each.key].id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  for_each = var.buckets
  bucket   = aws_s3_bucket.buckets[each.key].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Configuración Bucket "web-produccion" Web-Site
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.buckets["web-produccion"].id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.buckets["web-produccion"].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.buckets["web-produccion"].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.buckets["web-produccion"].id}/*"
      }
    ]
  })
  # Espera a que el bucket s3 esté creado antes de aplicar la política
  depends_on = [aws_s3_bucket.buckets]
}

# Localización archivos index.html y error.html
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.buckets["web-produccion"].id
  key    = "index.html"
  source = "${path.root}/web/index.html" # 🔹 Asegúrate de tener este archivo en la misma carpeta de Terraform o colocar la ubicacion correcta
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.buckets["web-produccion"].id
  key    = "error.html"
  source = "${path.root}/web/error.html" # 🔹 Asegúrate de tener este archivo en la misma carpeta de Terraform o colocar la ubicacion correcta
  content_type = "text/html"
}
