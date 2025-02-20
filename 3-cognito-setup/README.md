# AWS Cognito with FastAPI using Terrform

A project that combines AWS Cognito (provisioned via Terraform) with a FastAPI backend for user authentication.

## Project Structure

```
.
├── app/
│   └── main.py          # FastAPI application with Cognito integration
├── main.tf              # Main Terraform configuration for Cognito
├── variables.tf         # Terraform input variables
└── output.tf           # Terraform outputs
```

## Features

- AWS Cognito User Pool with email-based authentication
- FastAPI backend with endpoints for:
  - User signup
  - Email verification
  - Login (with JWT tokens)
  - Logout (global sign-out)

## Prerequisites

- Python 3.8+
- Terraform
- AWS CLI configured
- FastAPI dependencies
(`poetry add fastapi uvicorn boto3 python-dotenv pydantic[email]`)

## Terraform Setup

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan -out=myplan
```

3. Apply the configuration:
```bash
terraform apply "myplan"
```

4. Get the outputs (save these for FastAPI configuration):
```bash
terraform output cognito_user_pool_id
terraform output cognito_user_pool_client_id
terraform output cognito_user_pool_client_secret
```

## Get the state
```bash
terraform show -json > output.json
```

## FastAPI Setup

1. Set the required environment variables:
```bash
export COGNITO_USER_POOL_ID="your_user_pool_id"
export COGNITO_CLIENT_ID="your_client_id"
export COGNITO_CLIENT_SECRET="your_client_secret"
export AWS_REGION="your_aws_region"
```

2. Run the FastAPI server:
```bash
uvicorn app.main:app --reload
```

## API Endpoints

- `POST /signup`: Create a new user
  - Required: email, password
  
- `POST /verify`: Verify email with confirmation code
  - Required: email, code
  
- `POST /login`: Authenticate user
  - Required: email, password
  - Returns: access_token, id_token, refresh_token
  
- `POST /logout`: Global sign-out
  - Required: access_token

## Security Notes

- The Cognito Client Secret is marked as sensitive in Terraform outputs
- HMAC-SHA256 is used for request signing
- Email verification is required before login
- Passwords must be at least 8 characters long

## Customization

Modify `variables.tf` to customize:
- User Pool name
- App Client name
- Callback URLs
- Logout URLs

## License

[Add your license here]