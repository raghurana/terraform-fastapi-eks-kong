# upwork-eks-fastapi-kong-cognito

This project demonstrates how to deploy a FastAPI application on AWS EKS with Kong API Gateway and Cognito User Pool.


## Step 1. Create a EKS cluster

```bash
cd eks-deployment

# And follow the instructions in the README.md
```

## Step 2. Deploy Kong API Gateway

```bash
cd kong-deployment

# And follow the instructions in the README.md
```

## Step 3. Deploy Cognito User Pool

```bash
cd cognito-deployment

# And follow the instructions in the README.md
```

## Step 4. Deploy FastAPI application

```bash
cd fastapi-deployment

# And follow the instructions in the README.md
```

## Access the FastAPI application

```bash
# Get the LoadBalancer URL
kubectl get svc -n kong

# copy the external IP of the kong proxy service
```

```sh
# curl to the fastapi service
curl -X GET http://<EXTERNAL_IP>/fastapi-service/health

# You should see the response as:
{"status":"ok"}
```


