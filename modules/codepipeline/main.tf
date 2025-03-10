resource "aws_codepipeline" "web_pipeline" {
  name     = "${var.name_codepipeline}-${var.environment}"
  role_arn = var.arn_role

  artifact_store {
    type     = "S3"
    location = var.all_bucket_id[1]
  }

  stage {
    name = "Source"

    action {
      name             = "S3_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        S3Bucket = var.all_bucket_id[0]
        S3ObjectKey = "codigo.zip"
      }
    }
  }

/*   stage {
    name = "Build"

    action {
      name             = "Build_Site"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.site_build.name
      }
    }
  }

  stage {
    name = "Test"

    action {
      name            = "Run_Tests"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["build_output"]
      output_artifacts = ["test_results"]
      configuration = {
        ProjectName = aws_codebuild_project.site_tests.name
      }
    }
  } */

  stage {
    name = "Deploy"

    action {
      name             = "Deploy_to_S3"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      input_artifacts  = ["build_output"]
      configuration = {
        S3Bucket     = var.all_bucket_id[2]
        Extract      = "true"
      }
    }
  }
  
  tags = {
    "environment" = var.environment 
  }
}