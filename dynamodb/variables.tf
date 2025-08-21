variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "created_date" {
  description = "Creation date for tagging (YYYYMMDD format)"
  type        = string
  default     = "20250820"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}