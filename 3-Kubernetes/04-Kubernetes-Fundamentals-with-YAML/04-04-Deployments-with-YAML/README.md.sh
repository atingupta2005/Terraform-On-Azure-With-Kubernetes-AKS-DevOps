# Deployments with YAML

## Step-01: Copy templates from ReplicaSet
- Copy templates from ReplicaSet and change the `kind: Deployment`
- Update Container Image version to `3.0.0`
- Change all names to Deployment
- Change all labels and selectors to `myapp3`


# Create Deployment
kubectl apply -f kube-manifests/02-deployment-definition.yml


kubectl get deploy


kubectl get rs


kubectl get po


# Create LoadBalancer Service
kubectl apply -f kube-manifests/03-deployment-LoadBalancer-service.yml


# List Service
kubectl get svc


# Access Application
curl http://<Load-Balancer-Service-IP>

## API References
- [Deployment](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#deployment-v1-apps)
