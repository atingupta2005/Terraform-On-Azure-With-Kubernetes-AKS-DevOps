---
title: Azure AKS Pull ACR using Service Principal
description: Pull Docker Images from Azure Container Registry using Service Principal to Azure AKS Node pools
---

# Azure AKS Pull Docker Images from ACR using Service Principal

## Step-00: Pre-requisites
- We should have Azure AKS Cluster Up and Running.
- We have created a new aksdemo2 cluster as part of Azure Virtual Nodes demo in previous section.
- We are going to leverage the same cluster for all 3 demos planned for Azure Container Registry and AKS.
```
# Configure Command Line Credentials
az aks get-credentials --name ating-AKSCluster --resource-group rg-ating-aks-cluster
```
```
# Verify Nodes
kubectl get nodes
```

## Step-01: Introduction
- We are going to pull Images from Azure Container Registry which is not attached to AKS Cluster.
- We are going to do that using Azure Service Principals.
- Build a Docker Image from our Local Docker on our Desktop
- Push to Azure Container Registry
- Create Service Principal and using that create Kubernetes Secret.
- Using Kubernetes Secret associated to Pod Specificaiton, pull the docker image from Azure Container Registry and Schedule on Azure AKS NodePools


## Step-02: Create Azure Container Registry
- Go to Services -> Container Registries
- Click on **Add**
- Subscription: Azure Pass - Sponsorship
- Resource Group: acr-rg2
- Registry Name: acrdemo2ss   (NAME should be unique across Azure Cloud)
- Location: Central US
- SKU: Basic  (Pricing Note: $0.167 per day)
- Click on **Review + Create**
- Click on **Create**

## Step-02: Build Docker Image Locally
```
# Export Command
export ACR_NAME=acr0612ating
export ACR_REGISTRY=$ACR_NAME.azurecr.io
export ACR_NAMESPACE=app2
export ACR_IMAGE_NAME=acr-app2
export ACR_IMAGE_TAG=v1
export SERVICE_PRINCIPAL_NAME=$ACR_NAME-sp
echo $ACR_REGISTRY, $ACR_NAMESPACE, $ACR_IMAGE_NAME, $ACR_IMAGE_TAG
echo $ACR_NAME, $SERVICE_PRINCIPAL_NAME
```

```
# Change Directory
cd docker-manifests
```

```
# Docker Build
docker build -t $ACR_IMAGE_NAME:$ACR_IMAGE_TAG .
```

```
# List Docker Images
docker images
```

## Step-03: Create Service Principal to access Azure Container Registry
```
# Obtain the full registry ID for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)
echo $ACR_REGISTRY_ID
```

```
# Create the service principal with rights scoped to the registry.
sudo apt install jq
sp_details=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --output json)
echo $sp_details | jq '.'
SP_PASSWD=$(echo $sp_details | jq '.password' | tr -d '"')
SP_APP_ID=$(echo $sp_details | jq '.appId' | tr -d '"')
```

```
# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $SP_APP_ID"
echo "Service principal password: $SP_PASSWD"
```


## Step-04: Disable Docker Login for ACR Repository
- Go to Services -> Container Registries -> acrdemo2ss
- Go to **Access Keys**
- Click on **Disable Admin User**

## Step-05: Push Docker Image to Azure Container Registry

### Build, Test Locally, Tag and Push to ACR
```
# Tag
docker tag $ACR_IMAGE_NAME:$ACR_IMAGE_TAG $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_IMAGE_TAG
```

```
# List Docker Images to verify
docker images $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_IMAGE_TAG
```

```
# Log in to Docker with service principal credentials
docker login $ACR_REGISTRY --username $SP_APP_ID --password $SP_PASSWD
```

```
az acr login --name $ACR_NAME
```

```
# Push Docker Images
docker push $ACR_REGISTRY/$ACR_NAMESPACE/$ACR_IMAGE_NAME:$ACR_IMAGE_TAG
```

### Verify Docker Image in ACR Repository
- Go to Services -> Container Registries -> acrdemo2ss
- Go to **Repositories** -> **app2/acr-app2**


## Step-06: Create Image Pull Secret
```
kubectl delete secret $ACR_NAME-secret
```

```
kubectl create secret docker-registry $ACR_NAME-secret \
    --namespace default \
    --docker-server=$ACR_REGISTRY \
    --docker-username=$SP_APP_ID \
    --docker-password=$SP_PASSWD
```

```
# List Secrets
kubectl get secrets
```


## Step-07: Review, Update & Deploy to AKS & Test
### Update Deployment Manifest with Image Name, ImagePullSecrets
```yaml
    spec:
      containers:
        - name: acrdemo-localdocker
          image: acrdemo2ss.azurecr.io/app2/acr-app2:v1
          imagePullPolicy: Always
          ports:
            - containerPort: 80
      imagePullSecrets:
        - name: acrdemo2ss-secret           
```

### Deploy to AKS and Test
```
# Deploy
kubectl apply -f kube-manifests/
```
```
# List Pods
kubectl get pods
```
```
# Describe Pod
kubectl describe pod <pod-name>
```
```
# Get Load Balancer IP
kubectl get svc
```
```
# Access Application
curl http://<External-IP-from-get-service-output>
```

## Step-07: Clean-Up
```
# Delete Applications
kubectl delete -f kube-manifests/
```


## References
- [Azure Container Registry Authentication - Options](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication)
- [Pull images from an Azure container registry to a Kubernetes cluster](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-kubernetes)
