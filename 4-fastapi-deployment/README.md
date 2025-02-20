# Hosting FastAPI in EKS using Terraform

# Places to update info

1. Update the `terraform.tfvars` with the correct values to authenticate to AWS.

2. Update the `Dockerfile` with the correct values from the cognito configurations.


## Dockerize and push the FastAPI application to ECR

1. Authenticate to AWS ECR

``` sh
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
```




2. Create the repo

```sh
aws ecr create-repository --repository-name fast-api-demo --region us-east-1

```

3. Build the docker image

```sh
docker build --platform=linux/amd64 -t fast-api-demo .
```


2. Tag the container 
```sh
docker tag fast-api-demo:latest <AWS_ID>.dkr.ecr.<REGION>.amazonaws.com/fast-api-demo:latest
```


3. Push the container
```sh
docker push fast-api-demo:latest <AWS_ID>.dkr.ecr.<REGION>.amazonaws.com/fast-api-demo:latest
```

## Create EKS FastAPI deployment using Terraform

1. Initialize the terraform

```sh
terraform init
```

2. Plan the terraform

```sh
terraform plan -out=myplan
```

3. Apply the terraform

```sh
terraform apply "myplan"
```

## Configure the FatsAPI service
```sh
$ cd helm

$ kubectl apply -f templates/fastapi/service.yaml
```

## Configure the FatsAPI ingress
```sh
$ kubeclt apply -f templates/fastapi/ingress.yaml
```

