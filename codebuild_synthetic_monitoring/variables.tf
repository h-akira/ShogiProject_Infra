variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string
  default     = "build-sgp-synthetic-monitoring"
}

variable "created_date" {
  description = "Creation date for tagging (YYYYMMDD format)"
  type        = string
  default     = "20251012"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/h-akira/ShogiProject_SyntheticMonitoring"
}

variable "codebuild_service_role_name" {
  description = "Name of the CodeBuild service role"
  type        = string
  default     = "codebuild-build-sgp-synthetic-monitoring-service-role"
}

variable "codebuild_base_policy_name" {
  description = "Name of the CodeBuild base policy"
  type        = string
  default     = "CodeBuildBasePolicy-build-sgp-synthetic-monitoring-ap-northeast-1"
}

variable "common_exec_sam_policy_name" {
  description = "Name of the common exec SAM policy"
  type        = string
  default     = "policy-sgp-synthetic-monitoring-exec-sam"
}

variable "codeconnections_policy_name" {
  description = "Name of the CodeConnections source credentials policy"
  type        = string
  default     = "CodeBuildCodeConnectionsSourceCredentialsPolicy-build-sgp-synthetic-monitoring-ap-northeast-1"
}

variable "codestar_connection_id" {
  description = "ID of the CodeStar/CodeConnections connection"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}
