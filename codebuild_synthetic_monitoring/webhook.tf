resource "aws_codebuild_webhook" "sgp_synthetic_monitoring" {
  project_name = aws_codebuild_project.sgp_synthetic_monitoring.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "refs/heads/main"
    }
  }
}
