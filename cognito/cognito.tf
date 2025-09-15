# Cognito User Pool
resource "aws_cognito_user_pool" "main" {
  name = var.user_pool_name
  
  # Password policy - matching actual configuration
  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    temporary_password_validity_days = 7
  }

  # Auto-verified attributes
  auto_verified_attributes = ["email"]

  # Username configuration - matching actual: email alias, case insensitive
  alias_attributes = ["email"]
  username_configuration {
    case_sensitive = false
  }
  
  # Account recovery - matching actual configuration
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Verification message template
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  # Admin create user config - matching actual settings
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  # MFA configuration
  mfa_configuration = "OFF"

  # Schema attributes - email is required
  schema {
    attribute_data_type = "String"
    name               = "email"
    required           = true
    mutable           = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  # Deletion protection
  deletion_protection = "ACTIVE"

  # Tags
  tags = {
    Name        = var.user_pool_name
    Environment = "production"
    ManagedBy   = "terraform"
  }

  lifecycle {
    # Prevent accidental destruction
    prevent_destroy = true
  }
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "main" {
  name         = var.user_pool_client_name
  user_pool_id = aws_cognito_user_pool.main.id

  # Client configuration
  generate_secret = true
  
  # Auth flows - matching actual configuration
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  # Token validity - matching actual configuration
  access_token_validity  = 5      # 5 minutes
  id_token_validity      = 5      # 5 minutes
  refresh_token_validity = 5      # 5 days

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  # OAuth configuration - completely disabled (not used by WAMBDA)
  callback_urls = []
  allowed_oauth_flows = []
  allowed_oauth_scopes = []
  allowed_oauth_flows_user_pool_client = false

  # Supported identity providers
  supported_identity_providers = ["COGNITO"]

  # Prevent user existence errors
  prevent_user_existence_errors = "ENABLED"

  # Token revocation
  enable_token_revocation = true
  enable_propagate_additional_user_context_data = false

  # Auth session validity
  auth_session_validity = 3

  lifecycle {
    # Prevent accidental destruction
    prevent_destroy = true
  }
}

