"""
FastAPI Sever with basic Cognito integration for:
1. Signup
2. Verify (confirm sign-up)
3. Login (admin initiate auth)
4. Logout (global sign-out)
"""

from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, EmailStr
from typing import Optional
import os
import boto3
import hmac
import hashlib
import base64

# Initialize FastAPI
app = FastAPI()

# Environment variables or set them as defaults for testing
COGNITO_USER_POOL_ID = os.getenv("COGNITO_USER_POOL_ID")
COGNITO_CLIENT_ID = os.getenv("COGNITO_CLIENT_ID")
COGNITO_CLIENT_SECRET = os.getenv("COGNITO_CLIENT_SECRET")
AWS_REGION = os.getenv("AWS_REGION")

cognito_client = boto3.client("cognito-idp", region_name=AWS_REGION)


class SignupRequest(BaseModel):
    email: EmailStr
    password: str

class VerifyRequest(BaseModel):
    email: EmailStr
    code: str

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class AuthTokens(BaseModel):
    access_token: str
    id_token: Optional[str] = None
    refresh_token: Optional[str] = None



# ================
def get_secret_hash(username: str, client_id: str, client_secret: str) -> str:
    """
    Returns the Cognito secret hash required for AuthParameters when
    since in our settings: generate_secret = true in the Cognito App Client.
    """
    message = username + client_id
    dig = hmac.new(
        client_secret.encode("UTF-8"),
        msg=message.encode("UTF-8"),
        digestmod=hashlib.sha256,
    ).digest()
    return base64.b64encode(dig).decode()


# --------------------------------------------------
# API Endpoints
@app.post("/signup", status_code=status.HTTP_201_CREATED)
def signup(request: SignupRequest):
    """
    Create a new Cognito user. A confirmation code will be sent to the user's email.
    The user must confirm the sign-up using /verify endpoint.
    """
    try:
        secret_hash = get_secret_hash(request.email, COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET)
        cognito_client.sign_up(
            ClientId=COGNITO_CLIENT_ID,
            SecretHash=secret_hash,
            Username=request.email,
            Password=request.password,
            UserAttributes=[
                {
                    "Name": "email",
                    "Value": request.email,
                },
            ],
        )
        return {"message": "Signup successful. Check your email for a confirmation code."}
    except cognito_client.exceptions.UsernameExistsException:
        raise HTTPException(status_code=400, detail="User already exists.")
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.post("/verify")
def verify(request: VerifyRequest):
    """
    Verify the sign-up with the confirmation code sent to the user's email.
    """
    try:
        secret_hash = get_secret_hash(request.email, COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET)
        cognito_client.confirm_sign_up(
            ClientId=COGNITO_CLIENT_ID,
            SecretHash=secret_hash,
            Username=request.email,
            ConfirmationCode=request.code,
        )
        return {"message": "User verified successfully."}
    except cognito_client.exceptions.CodeMismatchException:
        raise HTTPException(status_code=400, detail="Invalid verification code.")
    except cognito_client.exceptions.UserNotFoundException:
        raise HTTPException(status_code=404, detail="User not found.")
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.post("/login", response_model=AuthTokens)
def login(request: LoginRequest):
    """
    Login a user. Returns Cognito tokens (access_token, id_token, refresh_token).
    Uses 'ADMIN_NO_SRP_AUTH' flow for simplicity.
    """
    try:
        secret_hash = get_secret_hash(request.email, COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET)
        response = cognito_client.admin_initiate_auth(
            UserPoolId=COGNITO_USER_POOL_ID,
            ClientId=COGNITO_CLIENT_ID,
            AuthFlow="ADMIN_NO_SRP_AUTH",
            AuthParameters={
                "USERNAME": request.email,
                "PASSWORD": request.password,
                "SECRET_HASH": secret_hash,
            },
        )
        auth_result = response["AuthenticationResult"]
        tokens = AuthTokens(
            access_token=auth_result["AccessToken"],
            id_token=auth_result.get("IdToken"),
            refresh_token=auth_result.get("RefreshToken"),
        )
        return tokens
    except cognito_client.exceptions.NotAuthorizedException:
        raise HTTPException(status_code=401, detail="Incorrect username or password.")
    except cognito_client.exceptions.UserNotConfirmedException:
        raise HTTPException(
            status_code=403, detail="User is not confirmed. Please verify via /verify."
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.post("/logout")
def logout(access_token: str):
    """
    Logout (Global sign-out) using the user's Access Token. This invalidates the refresh tokens too.
    """
    try:
        cognito_client.global_sign_out(AccessToken=access_token)
        return {"message": "Logout successful. All sessions invalidated."}
    except cognito_client.exceptions.NotAuthorizedException:
        raise HTTPException(status_code=401, detail="Invalid or expired access token.")
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
