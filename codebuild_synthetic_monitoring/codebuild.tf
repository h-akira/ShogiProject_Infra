resource "aws_codebuild_project" "sgp_synthetic_monitoring" {
  name               = var.codebuild_project_name
  service_role       = aws_iam_role.codebuild_service_role.arn
  queued_timeout     = 60

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                      = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    type                       = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode            = true
  }

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    buildspec       = ""

    git_submodules_config {
      fetch_submodules = false
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      status = "DISABLED"
    }
  }

  project_visibility = "PRIVATE"

  tags = {
    Name        = var.codebuild_project_name
    Environment = var.environment
    Created     = var.created_date
  }
}
