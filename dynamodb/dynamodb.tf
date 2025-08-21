resource "aws_dynamodb_table" "sgp_main" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "cgsi_pk"
    type = "S"
  }

  attribute {
    name = "clsi_sk"
    type = "S"
  }

  attribute {
    name = "created"
    type = "S"
  }

  attribute {
    name = "latest_access"
    type = "S"
  }

  attribute {
    name = "latest_update"
    type = "S"
  }

  # Local Secondary Indexes
  local_secondary_index {
    name            = "CreatedIndex"
    range_key       = "created"
    projection_type = "INCLUDE"
    non_key_attributes = ["clsi_sk", "public", "cgsi_pk"]
  }

  local_secondary_index {
    name            = "CommonLSI"
    range_key       = "clsi_sk"
    projection_type = "ALL"
  }

  local_secondary_index {
    name            = "LatestAccessIndex"
    range_key       = "latest_access"
    projection_type = "INCLUDE"
    non_key_attributes = ["clsi_sk", "public", "cgsi_pk"]
  }

  local_secondary_index {
    name            = "LatestUpdateIndex"
    range_key       = "latest_update"
    projection_type = "INCLUDE"
    non_key_attributes = ["clsi_sk", "public", "cgsi_pk"]
  }

  # Global Secondary Indexes
  global_secondary_index {
    name            = "CommonGSI"
    hash_key        = "cgsi_pk"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "SwapIndex"
    hash_key        = "sk"
    range_key       = "pk"
    projection_type = "ALL"
  }

  tags = {
    Name        = var.dynamodb_table_name
    Environment = var.environment
    Created     = var.created_date
  }
}