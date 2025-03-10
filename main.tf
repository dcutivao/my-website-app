module "s3" {
  source      = "./modules/s3"
  environment = var.environment
  buckets     = var.buckets
}

/* module "codepipeline" {
  source = "./modules/codepipeline"
  environment       = var.environment
  name_codepipeline = var.name_codepipeline
  arn_role          = module.iam.arn_role
  all_bucket_id     = module.s3.all_bucket_id
} */

module "iam" {
  source      = "./modules/iam"
  bucket_arns = module.s3.all_bucket_arn
}