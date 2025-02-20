resource "aws_cognito_user_pool" "main" {
  name = var.cognito_user_pool_name

  # password policy
  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  # Multi-Factor Auth (optional, here set to OFF)
  mfa_configuration = "OFF"

  # Optional: account recovery settings
  account_recovery_setting {
    recovery_mechanism {
        name     = "verified_email"
        priority = 1
    }
  }

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

}


resource "aws_cognito_user_pool_client" "main" {
  name            = var.cognito_app_client_name
  user_pool_id    = aws_cognito_user_pool.main.id
  generate_secret = true  # Whether to generate a client secret

  explicit_auth_flows = [
    "ADMIN_NO_SRP_AUTH",
    "USER_PASSWORD_AUTH",
  ]

  # OAuth configuration
  allowed_oauth_flows       = ["implicit", "code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes      = [
    "email",
    "openid",
    "profile"
  ]

  callback_urls = var.cognito_callback_urls
  logout_urls   = var.cognito_logout_urls

  supported_identity_providers = ["COGNITO"]
}


#############################
# User Pool Domain (Optional)
#############################
# If you want a Cognito-hosted UI at a specific domain, you can create a user pool domain:
# resource "aws_cognito_user_pool_domain" "main" {
#   domain       = "my-cognito-domain-prefix"
#   user_pool_id = aws_cognito_user_pool.main.id
# }