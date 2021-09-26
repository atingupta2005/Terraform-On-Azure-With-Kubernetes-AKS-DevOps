# Create Namespace

- First Time - Login to Azure
```
az login
```

- First Time - Connect to AKS
```
az account set --subscription 633ef4c3-2130-49e8-8a79-628a449f1987
az aks get-credentials --resource-group AKS-RG --name aks-test
```

- Change context to AKS cluster
```
kubectl config use-context "aks-test"
```

- First Time: Create name space
```
kubectl create namespace "ns-$USER"
```

- Get all the namespaces
```
kubectl get namespaces
```

- Set my namespace
```
kubectl config set-context --current --namespace="ns-$USER"
```

- Get all my pods
```
kubectl get pods
```
