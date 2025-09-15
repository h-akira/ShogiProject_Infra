variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "shogi"
}


variable "user_pool_name" {
  description = "Cognito User Pool name"
  type        = string
  default     = "main-user-pool"
}

variable "user_pool_client_name" {
  description = "Cognito User Pool Client name"
  type        = string
  default     = "main-client"
}