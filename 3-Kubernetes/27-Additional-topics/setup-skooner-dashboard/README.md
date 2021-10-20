
```
public_ip_ingress=$(az network public-ip create --resource-group MC_rg-ating-aks-cluster_ating-AKSCluster_eastus --name myAKSPublicIPForIngress --sku Basic --allocation-method static --query publicIp.ipAddress -o tsv)
echo $public_ip_ingress
```

```
# Add the official stable repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add stable https://charts.helm.sh/stable/
helm repo update
```

```
# Optional - if error
helm uninstall ingress-nginx  --namespace ingress-basic
kubectl delete ns ingress-basic
```

```
kubectl create ns ingress-basic
```

```
helm install ingress-nginx ingress-nginx/ingress-nginx \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.service.externalTrafficPolicy=Local \
    --set controller.service.loadBalancerIP=$public_ip_ingress
```

```
# List Services with labels
kubectl get service -l app.kubernetes.io/name=ingress-nginx --namespace ingress-basic
kubectl describe service -l app.kubernetes.io/name=ingress-nginx --namespace ingress-basic
```

```
# List Pods
kubectl get pods -n ingress-basic
```

```
kubectl get all -n ingress-basic
```

```
# Access Public IP
curl http://$public_ip_ingress
```
#Output should be
#404 Not Found from Nginx

```
echo "********** $(date '+%Y-%m-%d %H:%M:%S') 6. Installing K8s Dashboard"
#kubectl apply -f https://raw.githubusercontent.com/skooner-k8s/skooner/master/kubernetes-skooner.yaml
kubectl apply -f ./k8s-manifests/
kubectl create serviceaccount k8dash-sa
kubectl create clusterrolebinding k8dash-sa --clusterrole=cluster-admin --serviceaccount=default:k8dash-sa
```

```
echo "********** $(date '+%Y-%m-%d %H:%M:%S') 7. Retrieving K8s Dashboard Token"
K8S_SECRET=$(kubectl get serviceaccount k8dash-sa -o jsonpath="{.secrets[0].name}")
K8S_TOKEN=$(kubectl get secret "$K8S_SECRET" --cluster "$CLUSTER_NAME" -o jsonpath="{.data.token}" | base64 --decode)
```

```
echo $K8S_TOKEN
echo http://$public_ip_ingress
```


# Cleanup
```
#kubectl delete -f https://raw.githubusercontent.com/skooner-k8s/skooner/master/kubernetes-skooner.yaml
kubectl delete -f ./k8s-manifests/
kubectl delete  serviceaccount k8dash-sa
kubectl delete  clusterrolebinding k8dash-sa
helm uninstall ingress-nginx  --namespace ingress-basic
kubectl delete  ns ingress-basic
az network public-ip delete -g MC_rg-ating-aks-cluster_ating-AKSCluster_eastus -n myAKSPublicIPForIngress
```

```
kubectl get ns
kubectl get all
```
