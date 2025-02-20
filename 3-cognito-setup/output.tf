# NOTE: This secret is stored in Terraform state. 
# Handle carefully for production environments.

output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_user_pool_client_id" {
  description = "The ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.main.id
}

output "cognito_user_pool_client_secret" {
  description = "The Client Secret of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.main.client_secret
  sensitive = true

}
