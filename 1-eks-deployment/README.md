# aws-kube-kong-cog-tf

# 1. Create a EKS cluster using terraform

## Init Terraform

```bash
terraform init
```

## Plan Terraform

```bash
terraform plan -out=myplyan
```

## Apply Terraform

```bash
terraform apply "myplan"
```

# 2. Configure EKS cluster with KubeConfig and Access entry

## Add Access entry to EKS cluster

```bash
aws eks create-access-entry --cluster-name <CLUSTER_NAME> --principal-arn arn:aws:iam::<ACCOUNT_ID>:role/<YOUR_CLUSTER_NAME> --type EC2_LINUX

# Or use GUI to add access entry
```

## Add eks config to kubeconfig

```bash
aws eks update-kubeconfig --name <CLUSTER_NAME> --region <REGION>
```

# 3. Install Load Balancer Controller

## Add the charts for Load Balancer

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
```

## Download the policy

```bash
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
```

## Create the policy

```bash
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
```

## Create the service account

```bash
eksctl create iamserviceaccount \
  --cluster ss-test-cluster \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```

## Install the Load Balance Controller

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=ss-test-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

## Verify the Load Balancer Controller

```bash
aws elbv2 describe-load-balancers --query "LoadBalancers[*].[DNSName,State.Code]" --output table 
```

```bash
kubectl get pods -n kube-system
```

# 4. Add Fargate Ngnix

## Create a namespace for fargate

```bash
kubectl create namespace fargate-apps
```


## Add fargate ngnix

```bash
kubectl apply -f fargate-nginx.yaml
```

## Add ngnix service

```bash
kubectl apply -f ngnix-service.yaml
```

## List the security groups

```bash
aws eks describe-cluster --name ss-test-cluster --query cluster.resourcesVpcConfig.securityGroupIds
```

## Check permissions in security group

```bash
aws ec2 describe-security-groups --group-ids sg-<security_g_id> --query "SecurityGroups[0].IpPermissions"
```

## Add ingress rule to security group

```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-<security_g_id> \
  --protocol tcp \
  --port 80 \
  --cidr
```

## Test the ngnix

```bash
kubectl get svc -n fargate-apps

# Get the external IP 

curl -X GET http://<EXTERNAL_IP>.com
```
