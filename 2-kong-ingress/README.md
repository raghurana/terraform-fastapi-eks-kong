# kong-ingress-terraform

Follow the instructions to setup kong api gateway using helm charts


## Prerequisites
- Add the kong helm repository

```sh
helm repo add kong https://charts.konghq.com
helm repo update
```

- Adding the charts for Load Balancer

```sh
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
```

## Download the policy
```sh
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
```

## Create the policy
```sh
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
```

## Create the service account
```sh
eksctl create iamserviceaccount \
  --cluster ss-test-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
``` 


## Install the Load Balance Controller
```sh
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=ss-test-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=ss-test-cluster \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller

## Steps to setup kong api gateway


1. Install the dependancies

```sh
helm dep up ./helm 
```

2. Create a namespace for kong

```sh
kubectl create namespace kong
```

3. Install the kong helm chart

```sh
helm install kong-gateway kong/kong -f helm/values.yaml --namespace kong
```


## Commands to check

1. Check the `default` ingress

```sh
kubectl get ingress -n default
```

2. Check for the services in `kong` namespace

```sh
kubectl get svc -n kong
```


## Check the deployment of the aws-load-balancer-controller
```sh 
kubectl get deployment -n kube-system aws-load-balancer-controller
```
