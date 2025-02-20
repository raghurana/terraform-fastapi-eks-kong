variable "cognito_user_pool_name" {
  type        = string
  description = "Name of the Cognito User Pool"
  default     = "my-user-pool"
}

variable "cognito_app_client_name" {
  type        = string
  description = "Name of the Cognito User Pool Client"
  default     = "my-app-client"
}

variable "cognito_callback_urls" {
  type        = list(string)
  description = "List of allowed callback URLs for the Cognito App Client"
  default     = ["https://yourapp.com/callback"]
}

variable "cognito_logout_urls" {
  type        = list(string)
  description = "List of allowed logout URLs for the Cognito App Client"
  default     = ["https://yourapp.com/logout"]
}
