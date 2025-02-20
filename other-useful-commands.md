---
---

## Other useful commands


### Check the cluster status

```sh
aws eks describe-cluster --name ss-test-cluster --region us-east-1 --query "cluster.status"
```

### Check the nodes in the cluster

```sh
kubectl get svc -n default
```

### Check the pods in the cluster

```sh
kubectl get pods -n default
```

### Check the logs of the pod

``` sh
kubectl logs fastapi-deployment-5c47cb97dc-8hgdr -n default
```

### Check the security group for the cluster 

```sh      
kubectl describe svc fastapi-service -n default
```

### Check the security group for the cluster 
```sh
aws eks describe-cluster --name ss-test-cluster  --query "cluster.resourcesVpcConfig.securityGroupIds"
```