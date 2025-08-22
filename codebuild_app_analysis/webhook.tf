resource "aws_codebuild_webhook" "sgp_app" {
  project_name = aws_codebuild_project.sgp_app.name
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